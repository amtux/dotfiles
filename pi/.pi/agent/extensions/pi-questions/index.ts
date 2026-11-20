import type { ExtensionAPI, ExtensionContext } from '@earendil-works/pi-coding-agent';
import { setTimeout as delay } from 'node:timers/promises';
import { Type } from 'typebox';

// Dialog titles are also shown outside the terminal by Pi's native OSC 7501 reporter.
function title(text: string): string {
  return Array.from(text.replace(/[\p{Cc}\p{Cf}]/gu, ' ').replace(/\s+/g, ' ').trim()).slice(0, 500).join('');
}

async function ask(ctx: ExtensionContext, question: string, options?: string[], signal?: AbortSignal) {
  if (!ctx.hasUI) throw new Error('ask_user requires an interactive UI. Ask in the response instead.');
  const prompt = title(question);
  if (!prompt) throw new Error('A non-empty question is required.');
  let answer: string | undefined;
  if (!signal?.aborted) {
    if (options?.length) {
      let other = 'Other (type an answer)';
      while (options.includes(other)) other += '…';
      answer = await ctx.ui.select(prompt, [...options, other], { signal });
      if (answer === other && !signal?.aborted) answer = await ctx.ui.input(prompt, undefined, { signal });
    } else {
      answer = await ctx.ui.input(prompt, undefined, { signal });
    }
  }
  if (signal?.aborted || answer === undefined || !answer.trim()) {
    return {
      content: [{ type: 'text' as const, text: 'User cancelled the question. This is not approval; do not proceed on an assumed answer.' }],
      details: { answer: null as string | null },
      terminate: true,
    };
  }
  return {
    content: [{ type: 'text' as const, text: `User answered: ${answer.slice(0, 8000)}` }],
    details: { answer: answer.slice(0, 8000) as string | null },
  };
}

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: 'ask_user',
    label: 'Ask User',
    description: 'Ask a blocking question in a real dialog. Pi reports the question title to Rex. Never include secrets in the question; answers are limited to 8000 characters.',
    promptSnippet: 'Ask a blocking question, optionally with choices and a free-text alternative',
    promptGuidelines: [
      'Use ask_user when a user decision is required before proceeding, rather than ending a normal response with a question.',
      'Call ask_user alone, not alongside other tools. Cancellation is not consent; do not assume an answer.',
      'Keep ask_user question text short and safe for desktop notifications. Never request passwords, tokens, or other secrets.',
    ],
    exposure: 'model-only',
    executionMode: 'sequential',
    parameters: Type.Object({
      question: Type.String({ minLength: 1, maxLength: 500 }),
      options: Type.Optional(Type.Array(Type.String({ minLength: 1, maxLength: 200 }), { minItems: 1, maxItems: 10 })),
    }),
    async execute(_toolCallId, params, signal, _onUpdate, ctx) {
      return ask(ctx, params.question, params.options, signal);
    },
  });

  pi.registerCommand('rex-question-test', {
    description: 'After 5 seconds, open a question dialog to test Rex notifications',
    async handler(_args, ctx) {
      if (!ctx.hasUI) throw new Error('This test requires an interactive UI.');
      ctx.ui.notify('Switch to another app; a question opens in 5 seconds.', 'info');
      await delay(5000);
      const result = await ask(ctx, 'Did Rex show this question in its notification?', ['Yes', 'No']);
      ctx.ui.notify(result.details.answer === null ? 'Question test cancelled.' : `Test answer: ${result.details.answer}`, 'info');
    },
  });
}
