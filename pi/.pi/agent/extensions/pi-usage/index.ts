import type { ExtensionAPI } from '@earendil-works/pi-coding-agent';
import { AnthropicUsageError, fetchAnthropicUsage } from './anthropic.ts';
import { fetchOpenAIUsage, UsageError } from './openai.ts';

export default function (pi: ExtensionAPI) {
  pi.registerCommand('usage-openai-sub', {
    description: 'Show OpenAI subscription limits and reset times',
    handler: async (_args, ctx) => {
      if (!ctx.hasUI) return;
      try {
        ctx.ui.notify('Fetching OpenAI subscription usage…', 'info');
        // Pi resolves the existing login and handles token refresh. Independent of ctx.model.
        const auth = await ctx.modelRegistry.getProviderAuth('openai-codex');
        const access = auth?.auth.apiKey;
        if (!access) throw new UsageError('Sign in to OpenAI Codex using /login to view subscription usage.');
        const report = await fetchOpenAIUsage(access);
        await ctx.ui.select(report, ['Close']);
      } catch (error) {
        ctx.ui.notify(error instanceof UsageError ? error.message :
          'Could not check OpenAI usage. Try /login or retry.', 'error');
      }
    },
  });

  pi.registerCommand('usage-anthropic-sub', {
    description: 'Show Claude subscription limits and reset times',
    handler: async (_args, ctx) => {
      if (!ctx.hasUI) return;
      try {
        ctx.ui.notify('Fetching Claude subscription usage…', 'info');
        const auth = await ctx.modelRegistry.getProviderAuth('anthropic');
        const report = await fetchAnthropicUsage(auth?.auth.apiKey);
        await ctx.ui.select(report, ['Close']);
      } catch (error) {
        ctx.ui.notify(error instanceof AnthropicUsageError ? error.message :
          'Could not check Anthropic usage. Try /login or retry.', 'error');
      }
    },
  });
}
