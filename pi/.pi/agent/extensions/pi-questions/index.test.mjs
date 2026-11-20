import assert from 'node:assert/strict';
import { test } from 'node:test';
import { execFileSync } from 'node:child_process';
import { createRequire } from 'node:module';
import { join } from 'node:path';

const root = join(execFileSync('npm', ['root', '-g'], { encoding: 'utf8' }).trim(), '@earendil-works/pi-coding-agent');
const require = createRequire(join(root, 'package.json'));
const { createJiti } = require('jiti');
const jiti = createJiti(import.meta.url, { alias: { typebox: require.resolve('typebox') } });
const { default: extension } = await jiti.import(new URL('./index.ts', import.meta.url).pathname);

function fixture(answer = 'Yes') {
  const tools = new Map();
  const commands = new Map();
  const calls = [];
  extension({ registerTool: tool => tools.set(tool.name, tool), registerCommand: (name, command) => commands.set(name, command) });
  const ctx = { hasUI: true, mode: 'tui', ui: {
    input: async (...args) => { calls.push(['input', ...args]); return answer; },
    select: async (...args) => { calls.push(['select', ...args]); return answer; },
    notify: (...args) => calls.push(['notify', ...args]),
  } };
  const tool = tools.get('ask_user');
  const run = (params, signal) => tool.execute('call-1', params, signal, undefined, ctx);
  return { tool, commands, ctx, calls, run };
}

test('asks a real input dialog with the question as its notification title', async () => {
  const f = fixture('Use the existing pane');
  const controller = new AbortController();
  const result = await f.run({ question: 'Which pane?' }, controller.signal);
  assert.deepEqual(f.calls, [['input', 'Which pane?', undefined, { signal: controller.signal }]]);
  assert.equal(result.details.answer, 'Use the existing pane');
  assert.match(result.content[0].text, /Use the existing pane/);
  assert.equal(f.tool.executionMode, 'sequential');
  assert.equal(f.tool.exposure, 'model-only');
});

test('offers choices with a free-text alternative', async () => {
  const f = fixture('Other (type an answer)');
  const result = await f.run({ question: 'Which editor?', options: ['Neovim', 'Vim'] });
  assert.deepEqual(f.calls.map(call => call[0]), ['select', 'input']);
  assert.deepEqual(f.calls[0][2], ['Neovim', 'Vim', 'Other (type an answer)']);
  assert.equal(result.details.answer, 'Other (type an answer)');
});

test('cancelled questions do not grant permission and stop automatic continuation', async () => {
  const f = fixture();
  f.ctx.ui.input = async () => undefined;
  const result = await f.run({ question: 'Proceed?' });
  assert.equal(result.details.answer, null);
  assert.equal(result.terminate, true);
  assert.match(result.content[0].text, /cancelled.*not approval/i);
});

test('noninteractive modes fail without opening a dialog', async () => {
  const f = fixture();
  f.ctx.hasUI = false;
  await assert.rejects(f.run({ question: 'Proceed?' }), /interactive/i);
  assert.deepEqual(f.calls, []);
});

test('already aborted questions never open a dialog', async () => {
  const f = fixture();
  const controller = new AbortController();
  controller.abort();
  const result = await f.run({ question: 'Proceed?' }, controller.signal);
  assert.equal(result.details.answer, null);
  assert.deepEqual(f.calls, []);
});

test('empty questions are rejected and notification control characters are removed', async () => {
  const f = fixture();
  await assert.rejects(f.run({ question: '   ' }), /question/i);
  await f.run({ question: 'Which\nfile?\u001b\u0007' });
  assert.equal(f.calls[0][1], 'Which file?');
});

test('a selected option returns directly without another dialog', async () => {
  const f = fixture('Neovim');
  const result = await f.run({ question: 'Which editor?', options: ['Neovim', 'Vim'] });
  assert.equal(result.details.answer, 'Neovim');
  assert.deepEqual(f.calls.map(call => call[0]), ['select']);
});

test('an abort while waiting cannot turn a late answer into consent', async () => {
  const f = fixture();
  const controller = new AbortController();
  f.ctx.ui.input = async () => { controller.abort(); return 'Yes'; };
  const result = await f.run({ question: 'Proceed?' }, controller.signal);
  assert.equal(result.details.answer, null);
  assert.equal(result.terminate, true);
});

test('questions flow through the installed native reporter and resume working afterward', async () => {
  const { ProgramStatusReporter } = await import(join(root, 'dist/modes/interactive/program-status-reporter.js'));
  const statuses = [];
  const reporter = new ProgramStatusReporter(() => ({ setProgramStatus: value => statuses.push(value) }), () => 'test session');
  reporter.handleEvent({ type: 'agent_start' });
  const f = fixture();
  // Mirrors the inspected interactive-mode.js input dialog boundary.
  f.ctx.ui.input = async question => {
    reporter.setBlocked('extension-dialog', { kind: 'question', message: question });
    reporter.setBlocked('extension-dialog', undefined);
    return 'Yes';
  };
  await f.run({ question: 'Reuse the existing pane?' });
  reporter.handleEvent({ type: 'agent_settled', aborted: false });
  assert.deepEqual(statuses.map(status => status.state), ['working', 'blocked', 'working', 'done']);
  assert.equal(statuses[1].kind, 'question');
  assert.equal(statuses[1].message, 'Reuse the existing pane?');
});

test('test command waits before asking, without invoking a model', async () => {
  const f = fixture('Yes');
  const started = Date.now();
  const pending = f.commands.get('rex-question-test').handler('', f.ctx);
  assert.deepEqual(f.calls.map(call => call[0]), ['notify']);
  await pending;
  assert.ok(Date.now() - started >= 4900);
  assert.deepEqual(f.calls.map(call => call[0]), ['notify', 'select', 'notify']);
});
