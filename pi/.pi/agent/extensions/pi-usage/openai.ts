export class UsageError extends Error {}

function record(value: unknown): Record<string, unknown> {
  if (!value || typeof value !== 'object' || Array.isArray(value)) {
    throw new UsageError('OpenAI returned an unexpected usage response.');
  }
  return value as Record<string, unknown>;
}

function resetTime(resetAt: number, now: number): string {
  const seconds = resetAt - now / 1000;
  if (seconds <= 0) return 'reset due';
  const minutes = Math.floor(seconds / 60);
  if (minutes < 1) return 'resets in <1m';
  const days = Math.floor(minutes / 1440);
  const hours = Math.floor(minutes / 60) % 24;
  return 'resets in ' + (days ? `${days}d ${hours}h` : hours ? `${hours}h ${minutes % 60}m` : `${minutes}m`);
}

export function formatOpenAIUsage(data: unknown, now = Date.now()): string {
  const limits = record(data).rate_limit;
  const rateLimit = limits == null ? {} : record(limits);
  const lines = [['primary_window', '5-hour'], ['secondary_window', 'Weekly']].map(([key, fallback]) => {
    if (rateLimit[key] == null) return `${fallback}: unavailable`;
    const window = record(rateLimit[key]);
    const used = window.used_percent;
    const duration = window.limit_window_seconds;
    const reset = window.reset_at;
    if (typeof used !== 'number' || !Number.isFinite(used) || used < 0 || used > 100 ||
      typeof duration !== 'number' || !Number.isSafeInteger(duration) || duration <= 0 ||
      typeof reset !== 'number' || !Number.isSafeInteger(reset) || reset < 0) {
      throw new UsageError('OpenAI returned an unexpected usage response.');
    }
    const label = duration === 18000 ? '5-hour' : duration === 604800 ? 'Weekly' : `${duration / 60}-minute window`;
    return `${label}: ${Math.round((100 - used) * 10) / 10}% left · ${resetTime(reset, now)}`;
  });
  return 'OpenAI subscription usage\n\n' + lines.join('\n');
}

export async function fetchOpenAIUsage(access: string, fetcher: typeof fetch = fetch): Promise<string> {
  let account: string;
  try {
    const parts = access.split('.');
    if (parts.length !== 3) throw new Error();
    const claims = record(JSON.parse(Buffer.from(parts[1], 'base64url').toString('utf8')));
    const accountId = record(claims['https://api.openai.com/auth']).chatgpt_account_id;
    if (typeof accountId !== 'string' || !/^[a-zA-Z0-9_-]{1,128}$/.test(accountId)) throw new Error();
    account = accountId;
  } catch {
    throw new UsageError('Sign in to OpenAI Codex using /login to view subscription usage.');
  }
  try {
    const response = await fetcher('https://chatgpt.com/backend-api/wham/usage', {
      method: 'GET', redirect: 'error', credentials: 'omit', signal: AbortSignal.timeout(15000),
      headers: {
        Authorization: `Bearer ${access}`, 'ChatGPT-Account-Id': account,
        Accept: 'application/json', 'User-Agent': 'codex-cli',
      },
    });
    if (response.status === 401) throw new UsageError('OpenAI login expired. Sign in again using /login.');
    if (response.status === 403) throw new UsageError('OpenAI usage access denied for this account.');
    if (response.status === 429) throw new UsageError('OpenAI usage is rate-limited. Try again later.');
    if (!response.ok) throw new UsageError(`OpenAI usage request failed (HTTP ${response.status}).`);
    return formatOpenAIUsage(await response.json());
  } catch (error) {
    if (error instanceof UsageError) throw error;
    throw new UsageError('Could not fetch OpenAI usage. The request failed, timed out, or returned invalid data.');
  }
}
