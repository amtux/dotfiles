import assert from 'node:assert/strict';
import { test } from 'node:test';
import { readFileSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';

const root = join(execFileSync('npm', ['root', '-g'], { encoding: 'utf8' }).trim(), '@earendil-works/pi-coding-agent');
const themeApi = await import(pathToFileURL(join(root, 'dist/modes/interactive/theme/theme.js')));
const { UserMessageComponent } = await import(pathToFileURL(join(root, 'dist/modes/interactive/components/user-message.js')));
const blue7 = '#394b70'; // Tokyo Night upstream palette, shared by Night, Storm, and Moon.

function resolve(theme, value) {
  const visited = new Set();
  while (value in theme.vars) {
    assert.ok(!visited.has(value), `Circular color variable: ${value}`);
    visited.add(value);
    value = theme.vars[value];
  }
  assert.match(value, /^#[0-9a-f]{6}$/i);
  return value;
}

function luminance(hex) {
  const rgb = hex.slice(1).match(/../g).map(part => {
    const c = parseInt(part, 16) / 255;
    return c <= 0.04045 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4;
  });
  return rgb.reduce((sum, c, i) => sum + c * [0.2126, 0.7152, 0.0722][i], 0);
}

function contrast(a, b) {
  const [lo, hi] = [luminance(a), luminance(b)].sort((x, y) => x - y);
  return (hi + 0.05) / (lo + 0.05);
}

for (const variant of ['night', 'storm', 'moon']) {
  const file = new URL(`./tokyonight-${variant}.json`, import.meta.url);
  test(`${variant}: no implicit terminal-default colors; user panel uses upstream blue7`, () => {
    const json = JSON.parse(readFileSync(file, 'utf8'));
    for (const [role, color] of Object.entries(json.colors)) {
      assert.notEqual(color, '', `${role} should not disappear into the terminal background`);
      resolve(json, color);
    }
    const bg = resolve(json, json.colors.userMessageBg);
    const fg = resolve(json, json.colors.userMessageText);
    assert.equal(bg, blue7);
    assert.ok(contrast(fg, bg) >= 4.5, 'User text must meet WCAG AA normal-text contrast');
    assert.ok(contrast(bg, json.vars.bg) >= 1.5, 'User panel must be visibly distinct from variant background');
    for (const role of ['selectedBg', 'customMessageBg', 'toolPendingBg', 'toolSuccessBg', 'toolErrorBg']) {
      assert.notEqual(bg, resolve(json, json.colors[role]), `User panel must differ from ${role}`);
    }
  });

  test(`${variant}: native Pi loader and user-message renderer use an explicit panel background`, () => {
    const loaded = themeApi.loadThemeFromPath(file.pathname, 'truecolor');
    themeApi.setThemeInstance(loaded);
    assert.equal(loaded.appearance, 'dark');
    const background = '\x1b[48;2;57;75;112m';
    assert.equal(loaded.getBgAnsi('userMessageBg'), background);
    const lines = new UserMessageComponent('A question with **bold** text and `code`.').render(60);
    assert.ok(lines.length > 0);
    assert.ok(lines.every(line => line.includes(background)), 'Panel background covers every rendered row, including padding');
  });
}
