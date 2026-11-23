export class AnthropicUsageError extends Error {}

function record(value: unknown): Record<string, unknown> {
  if (!value || typeof value !== 'object' || Array.isArray(value)) {
    throw new AnthropicUsageError('Anthropic returned an unexpected usage response.');
  }
  return value as Record<string, unknown>;
}

function formatUsage(data: unknown): string {
  const usage = record(data);
  const lines = [['five_hour', '5-hour'], ['seven_day', 'Weekly'],
    ['seven_day_sonnet', 'Weekly Sonnet'], ['seven_day_opus', 'Weekly Opus']].flatMap(([key, label], index) => {
    if (usage[key] == null) return index < 2 ? [`${label}: unavailable`] : [];
    const { utilization, resets_at: reset } = record(usage[key]);
    if (typeof utilization !== 'number' || !Number.isFinite(utilization) || utilization < 0) {
      throw new AnthropicUsageError('Anthropic returned an unexpected usage response.');
    }
    const time = typeof reset === 'string' ? Date.parse(reset) : NaN;
    const resetLabel = !Number.isFinite(time) ? 'reset time unavailable' :
      time <= Date.now() ? 'reset due' : `resets ${new Date(time).toLocaleString()}`;
    return [`${label}: ${Math.round(Math.max(0, 100 - utilization) * 10) / 10}% left · ${resetLabel}`];
  });
  return 'Claude subscription usage\n\n' + lines.join('\n');
}

export async function fetchAnthropicUsage(access: string | undefined): Promise<string> {
  if (!access?.startsWith('sk-ant-oat')) {
    throw new AnthropicUsageError('Sign in to Anthropic using /login to view Claude subscription usage.');
  }
  try {
    const response = await fetch('https://api.anthropic.com/api/oauth/usage', {
      method: 'GET', redirect: 'error', credentials: 'omit', signal: AbortSignal.timeout(15000),
      headers: { Authorization: `Bearer ${access}`, Accept: 'application/json', 'anthropic-beta': 'oauth-2025-04-20' },
    });
    if (response.status === 401) throw new AnthropicUsageError('Anthropic login expired. Sign in again using /login.');
    if (response.status === 403) throw new AnthropicUsageError('Anthropic usage access denied for this login.');
    if (response.status === 429) throw new AnthropicUsageError('Anthropic usage is rate-limited. Try again later.');
    if (!response.ok) throw new AnthropicUsageError(`Anthropic usage request failed (HTTP ${response.status}).`);
    return formatUsage(await response.json());
  } catch (error) {
    if (error instanceof AnthropicUsageError) throw error;
    throw new AnthropicUsageError('Could not fetch Anthropic usage. The request failed, timed out, or returned invalid data.');
  }
}
