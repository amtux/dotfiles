import type { ExtensionAPI, ExtensionContext } from '@earendil-works/pi-coding-agent';
import { createFooter } from './footer.ts';
import { SpeedMeter } from './metrics.ts';

export default function (pi: ExtensionAPI) {
  let meter = new SpeedMeter();
  let requestRender = () => {};
  let timer: ReturnType<typeof setInterval> | undefined;
  let active = false;
  const stopTimer = () => { clearInterval(timer); timer = undefined; };
  const start = (ctx: ExtensionContext) => {
    if (ctx.mode !== 'tui') return;
    meter.start(performance.now());
    active = true;
    stopTimer();
    timer = setInterval(() => requestRender(), 250);
    timer.unref();
    requestRender();
  };

  pi.on('session_start', (_event, ctx) => {
    if (ctx.mode !== 'tui') return;
    ctx.ui.setFooter((tui, theme, data) => {
      requestRender = () => tui.requestRender();
      return createFooter(ctx, theme, data,
        () => meter.label(performance.now(), (text, slow) => theme.fg(slow ? 'error' : 'dim', text)), requestRender);
    });
  });
  // turn_start is a fallback for transports that do not expose provider hooks.
  pi.on('turn_start', (_event, ctx) => start(ctx));
  pi.on('before_provider_request', (_event, ctx) => start(ctx));
  pi.on('message_update', (event, ctx) => {
    if (ctx.mode !== 'tui') return;
    const e = event.assistantMessageEvent;
    if (e.type === 'text_delta' || e.type === 'thinking_delta' || e.type === 'toolcall_delta') {
      meter.delta(e.delta, performance.now());
    }
  });
  pi.on('message_end', (event, ctx) => {
    if (ctx.mode !== 'tui' || event.message.role !== 'assistant') return;
    const m = event.message;
    meter.finish(m.usage.output, performance.now(),
      m.stopReason === 'aborted' || m.stopReason === 'error' ? m.stopReason : undefined);
    active = false;
    stopTimer();
    requestRender();
  });
  pi.on('agent_end', () => {
    if (active) meter.finish(0, performance.now(), 'interrupted');
    active = false;
    stopTimer();
    requestRender();
  });
  pi.on('model_select', () => { meter = new SpeedMeter(); requestRender(); });
  pi.on('thinking_level_select', () => requestRender());
  pi.on('session_shutdown', (_event, ctx) => {
    stopTimer();
    if (ctx.mode === 'tui') ctx.ui.setFooter(undefined);
    requestRender = () => {};
  });
}
