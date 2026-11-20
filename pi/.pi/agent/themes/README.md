# Tokyo Night themes

Night, Storm, and Moon follow the installed `folke/tokyonight.nvim` palettes (verified at commit `cdc07ac`), in `lua/tokyonight/colors/{night,storm,moon}.lua`. Night inherits Storm's colors except for its base backgrounds.

## User-message panels

All three variants use upstream `blue7` (`#394b70`) for `userMessageBg`, with their original foreground text colors. This keeps user messages distinct from assistant text, tool/custom-message panels, and selections.

Text contrast is 5.39:1 for Night/Storm and 5.84:1 for Moon. The audit found no other empty color values.

We tried the subtler community-theme role assignments (`bgDark` for Night/Storm, `bgHighlight` for Moon), but reverted them at the user's request because user messages looked like tool calls. No other palette or role changes were retained from that experiment.

Assistant text uses the terminal's background; Pi themes do not set the terminal's overall background.

## Verification

```sh
node --test ~/.pi/agent/themes/tokyonight.test.mjs
```

Tests check explicit colors, variable resolution, text contrast, separation from other panels, native Pi loading, and user-message background rendering (including padding and inline Markdown).

The active theme hot-reloads. Select each variant through `/settings` for a visual check.
