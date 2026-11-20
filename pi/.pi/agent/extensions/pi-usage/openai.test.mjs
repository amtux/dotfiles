import assert from 'node:assert/strict';
import { test } from 'node:test';
import { fetchOpenAIUsage, formatOpenAIUsage, UsageError } from './openai.ts';

const now = 1800000000000;
const window = (used, seconds, resetIn) => ({
  used_percent: used, limit_window_seconds: seconds, reset_at: now / 1000 + resetIn,
});
const payload = () => ({ rate_limit: {
  primary_window: window(17, 18000, 15660),
  secondary_window: window(6, 604800, 483480),
} });
const token = 'test.' + Buffer.from(JSON.stringify({
  'https://api.openai.com/auth': { chatgpt_account_id: 'test-account' },
})).toString('base64url') + '.signature';

test('formats remaining subscription limits and reset times', () => {
  assert.equal(formatOpenAIUsage(payload(), now),
    'OpenAI subscription usage\n\n5-hour: 83% left · resets in 4h 21m\nWeekly: 94% left · resets in 5d 14h');
});

test('zero remaining and expired reset times are not treated as missing', () => {
  const data = { rate_limit: { primary_window: window(100, 18000, -10) } };
  assert.match(formatOpenAIUsage(data, now), /5-hour: 0% left · reset due/);
  assert.match(formatOpenAIUsage(data, now), /Weekly: unavailable/);
});

test('absent windows are unavailable, not zero usage', () => {
  for (const data of [{}, { rate_limit: null }, { rate_limit: {} }]) {
    assert.equal(formatOpenAIUsage(data, now), 'OpenAI subscription usage\n\n5-hour: unavailable\nWeekly: unavailable');
  }
});

test('window labels follow actual durations instead of assuming primary means five hours', () => {
  const data = { rate_limit: {
    primary_window: window(5, 604800, 3600), secondary_window: window(10, 3600, 120),
  } };
  const text = formatOpenAIUsage(data, now);
  assert.match(text, /Weekly: 95% left/);
  assert.match(text, /60-minute window: 90% left/);
});

test('malformed responses are rejected with a safe error', () => {
  for (const data of [null, [], 'secret response', { rate_limit: 'secret' },
    { rate_limit: { primary_window: {} } }]) {
    assert.throws(() => formatOpenAIUsage(data, now), UsageError);
  }
  for (const used of [-1, 101, '17', NaN, Infinity]) {
    assert.throws(() => formatOpenAIUsage({ rate_limit: { primary_window: window(used, 18000, 1) } }, now), UsageError);
  }
  for (const [key, value] of [['reset_at', 'secret'], ['reset_at', -1], ['limit_window_seconds', 0]]) {
    const bad = window(17, 18000, 1);
    bad[key] = value;
    assert.throws(() => formatOpenAIUsage({ rate_limit: { primary_window: bad } }, now), UsageError);
  }
});

test('fetch uses only the verified HTTPS endpoint and existing bearer token, and forbids redirects', async () => {
  const result = await fetchOpenAIUsage(token, async (url, options) => {
    assert.equal(url, 'https://chatgpt.com/backend-api/wham/usage');
    assert.equal(options.method, 'GET');
    assert.equal(options.redirect, 'error');
    assert.equal(options.credentials, 'omit');
    assert.equal(options.headers.Authorization, 'Bearer ' + token);
    assert.equal(options.headers['ChatGPT-Account-Id'], 'test-account');
    assert.ok(options.signal instanceof AbortSignal);
    return Response.json(payload());
  });
  assert.match(result, /83% left/);
  assert.ok(!result.includes(token));
});

test('invalid or non-Codex credentials never cause a request', async () => {
  for (const access of ['', 'sk-secret', 'bad.jwt.token', 'x.' + Buffer.from('{"email":"secret@example.com"}').toString('base64url') + '.x']) {
    await assert.rejects(fetchOpenAIUsage(access, async () => {
      assert.fail('must not send invalid credentials');
    }), error => error instanceof UsageError && !error.message.includes(access || 'sk-secret'));
  }
});

for (const [status, expected] of [[401, /login/i], [403, /access denied/i], [429, /try again later/i], [500, /HTTP 500/]]) {
  test(`HTTP ${status} does not expose the response body`, async () => {
    await assert.rejects(fetchOpenAIUsage(token, async () => new Response('SECRET BODY', { status })), error =>
      error instanceof UsageError && expected.test(error.message) && !error.message.includes('SECRET'));
  });
}

test('network exceptions and invalid JSON never expose raw errors', async () => {
  for (const fake of [async () => { throw new Error('SECRET TOKEN'); },
    async () => new Response('SECRET NOT JSON', { status: 200 })]) {
    await assert.rejects(fetchOpenAIUsage(token, fake), error => error instanceof UsageError && !error.message.includes('SECRET'));
  }
});
