import { homedir } from 'node:os';
import type { ExtensionContext, ReadonlyFooterDataProvider, Theme } from '@earendil-works/pi-coding-agent';
import { truncateToWidth, visibleWidth } from '@earendil-works/pi-tui';

const compact = (n: number) => n < 1000 ? `${n}` : n < 10000 ? `${(n / 1000).toFixed(1)}k` : n < 1e6 ? `${Math.round(n / 1000)}k` : `${(n / 1e6).toFixed(1)}M`;
const singleLine = (s: string) => s.replace(/[\r\n\t]/g, ' ').replace(/ +/g, ' ').trim();

/** Right-align a group without wrapping; trim the left group first on small terminals. */
function alignRow(left: string, right: string, width: number): string {
  const fittedRight = truncateToWidth(right, width, '');
  const rightWidth = visibleWidth(fittedRight);
  const leftSpace = Math.max(0, width - rightWidth - 2);
  const fittedLeft = leftSpace > 0 ? truncateToWidth(left, leftSpace, '') : '';
  return fittedLeft + ' '.repeat(Math.max(0, width - visibleWidth(fittedLeft) - rightWidth)) + fittedRight;
}

/** Path/performance on row one; usage/model on row two. */
export function createFooter(
  ctx: ExtensionContext, theme: Theme, data: ReadonlyFooterDataProvider,
  speed: () => string, requestRender: () => void,
) {
  let cacheKey = '';
  let totals = { cacheRead: 0, cacheWrite: 0, cost: 0 };
  let hitRate: number | undefined;
  const unsubscribe = data.onBranchChange(requestRender);
  return {
    invalidate() { cacheKey = ''; },
    dispose: unsubscribe,
    render(width: number): string[] {
      const entries = ctx.sessionManager.getEntries();
      const key = `${ctx.sessionManager.getLeafId()}:${entries.length}`;
      if (key !== cacheKey) {
        totals = { cacheRead: 0, cacheWrite: 0, cost: 0 };
        hitRate = undefined;
        for (const entry of entries) {
          const usage = entry.type === 'message'
            ? (entry.message.role === 'assistant' || entry.message.role === 'toolResult' ? entry.message.usage : undefined)
            : ('usage' in entry ? entry.usage : undefined);
          if (!usage) continue;
          totals.cacheRead += usage.cacheRead;
          totals.cacheWrite += usage.cacheWrite;
          totals.cost += usage.cost.total;
          if (entry.type === 'message' && entry.message.role === 'assistant') {
            const prompt = usage.input + usage.cacheRead + usage.cacheWrite;
            hitRate = prompt > 0 ? usage.cacheRead / prompt * 100 : undefined;
          }
        }
        cacheKey = key;
      }
      const home = homedir();
      let cwd = ctx.cwd === home ? '~' : ctx.cwd.startsWith(home + '/') ? '~' + ctx.cwd.slice(home.length) : ctx.cwd;
      const branch = data.getGitBranch();
      const name = ctx.sessionManager.getSessionName();
      if (branch) cwd += ` (${branch})`;
      if (name) cwd += ` • ${name}`;
      const parts: string[] = [];
      if (totals.cacheWrite) parts.push('W' + compact(totals.cacheWrite));
      if (hitRate !== undefined && (totals.cacheRead || totals.cacheWrite)) parts.push(`CH${hitRate.toFixed(1)}%`);
      const subscription = ctx.model && (ctx.model.provider === 'kimi-coding' ||
        (ctx.modelRegistry.isUsingOAuth(ctx.model) && ctx.modelRegistry.getProvider(ctx.model.provider)?.auth?.oauth?.isSubscription === true));
      if (totals.cost || subscription) parts.push(`$${totals.cost.toFixed(3)}${subscription ? ' (sub)' : ''}`);
      const context = ctx.getContextUsage();
      const percent = context?.percent;
      const usageText = `${percent == null ? '?' : percent.toFixed(1) + '%'}/${compact(context?.contextWindow ?? ctx.model?.contextWindow ?? 0)}`;
      parts.push(theme.fg(percent != null && percent > 90 ? 'error' : percent != null && percent > 70 ? 'warning' : 'dim', usageText));
      const model = ctx.model;
      const level = model?.reasoning ? ctx.thinkingLevel : 'off';
      const modelDetails = theme.fg('dim', `${model ? `(${model.provider}) ${model.id}` : 'no-model'} · ${level}`);
      const lines = [
        alignRow(theme.fg('dim', singleLine(cwd)), speed(), width),
        alignRow(theme.fg('dim', parts.join(' ')), modelDetails, width),
      ];
      const statuses = [...data.getExtensionStatuses()].sort(([a], [b]) => a.localeCompare(b)).map(([, text]) => singleLine(text));
      if (statuses.length) lines.push(truncateToWidth(statuses.join(' '), width, ''));
      return lines;
    },
  };
}
