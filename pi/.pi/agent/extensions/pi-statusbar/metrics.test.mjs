import assert from 'node:assert/strict';
import { test } from 'node:test';
import { SpeedMeter } from './metrics.ts';

const color = (text, slow) => `<${slow ? 'red' : 'grey'}>${text}</${slow ? 'red' : 'grey'}>`;

test('only speed below 15 is red; latency stays grey', () => {
  const m = new SpeedMeter();
  m.start(0);
  m.delta('abcd', 4000);
  m.finish(14, 5000);
  assert.equal(m.label(5000, color), '<red>14.0 tok/s</red><grey> · 4.0s</grey>');
});

test('15 tok/s and faster stay grey', () => {
  for (const output of [15, 40, 100]) {
    const m = new SpeedMeter();
    m.start(0);
    m.delta('abcd', 1000);
    m.finish(output, 2000);
    assert.equal(m.label(2000, color), `<grey>${output.toFixed(1)} tok/s</grey><grey> · 1.0s</grey>`);
  }
});

test('live slow estimates are red, waiting and missing speeds remain grey', () => {
  const m = new SpeedMeter();
  assert.equal(m.label(0, color), '<grey>— tok/s</grey>');
  m.start(0);
  assert.equal(m.label(5000, color), '<grey>waiting 5.0s</grey>');
  m.delta('abcd', 5000);
  assert.equal(m.label(5000, color), '<grey>— tok/s</grey><grey> · 5.0s</grey>');
  assert.equal(m.label(6000, color), '<red>~1.0 tok/s</red><grey> · 5.0s</grey>');
});

test('idle and waiting do not invent a speed', () => {
  const m = new SpeedMeter();
  assert.equal(m.label(0), '— tok/s');
  m.start(100);
  assert.equal(m.label(1100), 'waiting 1.0s');
});

test('live estimate excludes initial wait and includes time between updates', () => {
  const m = new SpeedMeter();
  m.start(0);
  m.delta('abcd', 1000);
  m.delta('a'.repeat(36), 2000);
  assert.equal(m.label(2000), '~10.0 tok/s · 1.0s');
  assert.equal(m.label(3000), '~5.0 tok/s · 1.0s');
});

test('first chunk alone has no measurable generation interval', () => {
  const m = new SpeedMeter();
  m.start(0);
  m.delta('abcd', 1000);
  assert.equal(m.label(1000), '— tok/s · 1.0s');
});

test('final speed uses reported tokens, not the live estimate, and freezes', () => {
  const m = new SpeedMeter();
  m.start(0);
  m.delta('abcd', 1000);
  m.finish(100, 3000);
  assert.equal(m.label(3000), '50.0 tok/s · 1.0s');
  assert.equal(m.label(100000), '50.0 tok/s · 1.0s');
});

test('missing final usage remains explicitly estimated', () => {
  const m = new SpeedMeter();
  m.start(0);
  m.delta('a'.repeat(40), 1000);
  m.finish(0, 2000);
  assert.equal(m.label(9000), '~10.0 tok/s · 1.0s');
});

test('new request resets the measurement rather than including tool time', () => {
  const m = new SpeedMeter();
  m.start(0);
  m.delta('abcd', 1000);
  m.finish(100, 3000);
  m.start(30000);
  m.delta('abcd', 31000);
  m.finish(20, 32000);
  assert.equal(m.label(90000), '20.0 tok/s · 1.0s');
});

test('empty deltas and completion without streamed content have no TTFT', () => {
  const m = new SpeedMeter();
  m.start(0);
  m.delta('', 100);
  m.finish(100, 1000);
  assert.equal(m.label(1000), '— tok/s');
});

test('failed responses are labeled instead of presenting a success average', () => {
  const m = new SpeedMeter();
  m.start(0);
  m.delta('abcd', 1000);
  m.finish(100, 2000, 'aborted');
  assert.equal(m.label(3000), 'aborted · 1.0s');
});
