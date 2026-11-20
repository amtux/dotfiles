import assert from 'node:assert/strict';
import { test } from 'node:test';
import extension from './index.ts';

function setup(auth) {
  const commands = new Map();
  const notices = [];
  const dialogs = [];
  const requested = [];
  const ctx = {
    hasUI: true, model: { provider: 'some-other-provider' },
    modelRegistry: { getProviderAuth: async provider => { requested.push(provider); return auth; } },
    ui: { notify: (...args) => notices.push(args), select: async (...args) => { dialogs.push(args); } },
  };
  extension({ registerCommand: (name, options) => commands.set(name, options) });
  return { commands, ctx, notices, dialogs, requested, run: () => commands.get('usage-openai-sub').handler('', ctx) };
}
const token = 'test.' + Buffer.from(JSON.stringify({
  'https://api.openai.com/auth': { chatgpt_account_id: 'test-account' },
})).toString('base64url') + '.signature';

test('registers only the implemented provider command', () => {
  assert.deepEqual([...setup().commands.keys()], ['usage-openai-sub']);
});

test('uses the named provider, performs one request on demand, and shows a local dialog', async t => {
  const fetch = t.mock.method(globalThis, 'fetch', async () => Response.json({ rate_limit: {
    primary_window: { used_percent: 17, limit_window_seconds: 18000, reset_at: Math.floor(Date.now() / 1000) + 3600 },
  } }));
  const f = setup({ auth: { apiKey: token } });
  assert.equal(fetch.mock.callCount(), 0, 'loading the extension must not fetch');
  await f.run();
  assert.deepEqual(f.requested, ['openai-codex']);
  assert.equal(fetch.mock.callCount(), 1);
  assert.match(f.dialogs[0][0], /5-hour: 83% left/);
  assert.deepEqual(f.dialogs[0][1], ['Close']);
  assert.ok(!JSON.stringify(f.dialogs).includes(token));
});

test('missing login gives an actionable error without making a request', async t => {
  const fetch = t.mock.method(globalThis, 'fetch', async () => assert.fail('must not fetch'));
  const f = setup(undefined);
  await f.run();
  assert.equal(fetch.mock.callCount(), 0);
  assert.equal(f.dialogs.length, 0);
  assert.match(f.notices.at(-1)[0], /\/login/);
  assert.equal(f.notices.at(-1)[1], 'error');
});

test('auth exceptions do not leak SDK errors or tokens', async () => {
  const f = setup();
  f.ctx.modelRegistry.getProviderAuth = async () => { throw new Error('SECRET TOKEN'); };
  await f.run();
  assert.ok(!JSON.stringify(f.notices).includes('SECRET'));
  assert.equal(f.notices.at(-1)[1], 'error');
});

test('safe provider errors are shown without posting to the model', async t => {
  t.mock.method(globalThis, 'fetch', async () => new Response('SECRET BODY', { status: 429 }));
  const f = setup({ auth: { apiKey: token } });
  await f.run();
  assert.match(f.notices.at(-1)[0], /rate-limited/);
  assert.ok(!JSON.stringify(f.notices).includes('SECRET'));
  assert.equal(f.dialogs.length, 0);
});

test('non-UI contexts do nothing', async () => {
  const f = setup();
  f.ctx.hasUI = false;
  await f.run();
  assert.equal(f.requested.length + f.notices.length + f.dialogs.length, 0);
});
