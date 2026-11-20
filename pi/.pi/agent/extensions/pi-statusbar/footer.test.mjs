import assert from 'node:assert/strict';
import { test } from 'node:test';
import { execFileSync } from 'node:child_process';
import { createRequire } from 'node:module';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';

// Use the installed host's loader/dependencies, just as Pi loads extensions.
const root = join(execFileSync('npm', ['root', '-g'], { encoding: 'utf8' }).trim(), '@earendil-works/pi-coding-agent');
const require = createRequire(join(root, 'package.json'));
const { createJiti } = require('jiti');
const jiti = createJiti(import.meta.url, { alias: {
  '@earendil-works/pi-tui': require.resolve('@earendil-works/pi-tui'),
}});
const { createFooter } = await jiti.import(new URL('./footer.ts', import.meta.url).pathname);
const { default: extension } = await jiti.import(new URL('./index.ts', import.meta.url).pathname);
const { visibleWidth } = await import(pathToFileURL(require.resolve('@earendil-works/pi-tui')));

function fixture() {
  const entries = [{ type: 'message', message: { role: 'assistant', usage: {
    input: 100, output: 50, cacheRead: 900, cacheWrite: 0, cost: { total: 0.123 },
  } } }];
  const statuses = new Map();
  const ctx = {
    cwd: '/tmp/project', model: { provider: 'openai-codex', id: 'gpt-test', reasoning: true }, thinkingLevel: 'medium',
    modelRegistry: { isUsingOAuth: () => true, getProvider: () => ({ auth: { oauth: { isSubscription: true } } }) },
    sessionManager: { getEntries: () => entries, getLeafId: () => 'leaf', getSessionName: () => 'test session' },
    getContextUsage: () => ({ tokens: 1000, contextWindow: 100000, percent: 1 }),
  };
  let unsubscribe = false;
  const footer = createFooter(ctx, { fg: (_color, text) => text }, {
    getGitBranch: () => 'main', getExtensionStatuses: () => statuses,
    onBranchChange: () => () => { unsubscribe = true; },
  }, () => '42.0 tok/s · 1.2s', () => {});
  return { footer, ctx, entries, statuses, unsubscribed: () => unsubscribe };
}

test('speed and latency are right-aligned on the path row, model stays on usage row', () => {
  const { footer } = fixture();
  const lines = footer.render(180);
  assert.equal(lines.length, 2);
  assert.match(lines[0], /project \(main\) • test session/);
  assert.match(lines[1], /^CH90.0% \$0.123 \(sub\) 1.0%\/100k/);
  assert.doesNotMatch(lines[1], /↑|↓|R900|\(auto\)/);
  assert.ok(lines[0].endsWith('42.0 tok/s · 1.2s'));
  assert.ok(lines[1].endsWith('(openai-codex) gpt-test · medium'));
  assert.doesNotMatch(lines[1], /tok\/s|1\.2s/);
  assert.equal(visibleWidth(lines[0]), 180);
  assert.equal(visibleWidth(lines[1]), 180);
});

test('split-pane width retains usage stats after moving performance to the first row', () => {
  const { footer } = fixture();
  const lines = footer.render(85);
  assert.match(lines[1], /^CH90.0% \$0.123 \(sub\) 1.0%\/100k/);
  assert.doesNotMatch(lines[1], /\(auto\)/);
  assert.ok(lines[0].endsWith('42.0 tok/s · 1.2s'));
  assert.ok(lines[1].endsWith('(openai-codex) gpt-test · medium'));
});

test('narrow and wide terminal widths never overflow or add rows', () => {
  const { footer, ctx } = fixture();
  ctx.model.id = '模型-🦊-long-name';
  for (const width of [1, 5, 20, 40, 80, 120, 240]) {
    const lines = footer.render(width);
    assert.equal(lines.length, 2);
    assert.ok(lines.every(line => visibleWidth(line) <= width), `width ${width}`);
  }
});

test('unrelated extension statuses remain visible and are sanitized', () => {
  const { footer, statuses } = fixture();
  statuses.set('another-extension', 'hello\nworld');
  assert.equal(footer.render(180)[2], 'hello world');
});

test('usage includes tool and compaction costs and refreshes on append', () => {
  const { footer, entries } = fixture();
  footer.render(180);
  entries.push({ type: 'compaction', usage: { input: 10, output: 5, cacheRead: 0, cacheWrite: 0, cost: { total: 0.01 } } });
  assert.match(footer.render(180)[1], /CH90.0% \$0.133 \(sub\)/);
  assert.doesNotMatch(footer.render(180)[1], /↑|↓|R900/);
});

test('model and thinking changes are reflected without reinstalling footer', () => {
  const { footer, ctx } = fixture();
  ctx.model = { provider: 'other', id: 'new-model', reasoning: false };
  assert.ok(footer.render(180)[1].endsWith('(other) new-model · off'));
  footer.dispose();
});

test('disposing footer removes its branch subscription', () => {
  const f = fixture();
  f.footer.dispose();
  assert.equal(f.unsubscribed(), true);
});

function loadExtension(mode = 'tui') {
  const handlers = new Map();
  const { ctx } = fixture();
  let footer;
  let renders = 0;
  ctx.mode = mode;
  ctx.ui = { setFooter: factory => {
    footer?.dispose();
    footer = factory?.({ requestRender: () => renders++ }, { fg: (_c, s) => s }, {
      getGitBranch: () => 'main', getExtensionStatuses: () => new Map(), onBranchChange: () => () => {},
    });
  } };
  extension({ on: (name, handler) => handlers.set(name, handler), getSettings: () => ({}) });
  return { emit: (name, event = {}) => handlers.get(name)?.(event, ctx), lines: () => footer?.render(180), renders: () => renders };
}

test('extension handles thinking, text, tool arguments, completion and shutdown', async () => {
  const f = loadExtension();
  try {
    f.emit('session_start');
    assert.match(f.lines()[0], /— tok\/s/);
    f.emit('turn_start');
    f.emit('before_provider_request');
    f.emit('message_update', { assistantMessageEvent: { type: 'start' } });
    assert.match(f.lines()[0], /waiting/);
    for (const type of ['thinking_delta', 'text_delta', 'toolcall_delta']) {
      f.emit('message_update', { assistantMessageEvent: { type, delta: 'abcd' } });
    }
    await new Promise(resolve => setTimeout(resolve, 300));
    assert.match(f.lines()[0], /~[\d.]+ tok\/s/);
    assert.ok(f.renders() > 0);
    f.emit('message_end', { message: { role: 'toolResult' } });
    assert.match(f.lines()[0], /~[\d.]+ tok\/s/);
    f.emit('message_end', { message: { role: 'assistant', usage: { output: 100 }, stopReason: 'stop' } });
    assert.doesNotMatch(f.lines()[0], /~/);
    f.emit('model_select');
    assert.match(f.lines()[0], /— tok\/s/);
  } finally {
    f.emit('session_shutdown');
    assert.equal(f.lines(), undefined);
  }
});

test('run ending before a message completes does not keep a waiting clock', () => {
  const f = loadExtension();
  try {
    f.emit('session_start');
    f.emit('turn_start');
    f.emit('agent_end');
    assert.match(f.lines()[0], /interrupted/);
    assert.doesNotMatch(f.lines()[0], /waiting/);
  } finally { f.emit('session_shutdown'); }
});

test('non-TUI modes do not install a footer', () => {
  const f = loadExtension('rpc');
  f.emit('session_start');
  f.emit('turn_start');
  f.emit('session_shutdown');
  assert.equal(f.lines(), undefined);
});
