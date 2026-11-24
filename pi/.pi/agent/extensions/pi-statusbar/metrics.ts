/** One model request. Live counts use a deliberately labeled chars/4 estimate. */
export class SpeedMeter {
  private requested?: number;
  private first?: number;
  private ended?: number;
  private characters = 0;
  private output = 0;
  private failure?: string;

  start(now: number) {
    this.requested = now;
    this.first = this.ended = undefined;
    this.characters = this.output = 0;
    this.failure = undefined;
  }

  delta(text: string, now: number) {
    if (!text || this.requested === undefined || this.ended !== undefined) return;
    this.first ??= now;
    this.characters += text.length;
  }

  finish(output: number, now: number, failure?: string) {
    this.ended = now;
    this.output = Number.isFinite(output) && output > 0 ? output : 0;
    this.failure = failure;
  }

  label(now: number, style: (text: string, slow: boolean) => string = text => text): string {
    if (this.requested === undefined) return style('— tok/s', false);
    const first = this.first === undefined ? '' : style(` · ${((this.first - this.requested) / 1000).toFixed(1)}s`, false);
    if (this.failure) return style(this.failure, false) + first;
    if (this.first === undefined) {
      return style(this.ended === undefined ? `waiting ${((now - this.requested) / 1000).toFixed(1)}s` : '— tok/s', false);
    }
    const seconds = ((this.ended ?? now) - this.first) / 1000;
    const exact = this.ended !== undefined && this.output > 0;
    // Burst-delivered replies (e.g. Anthropic) finish too fast for a rate; keep the reported count.
    if (seconds < 0.1) return style(exact ? `${this.output} tok` : '— tok/s', false) + first;
    const tokens = exact ? this.output : this.characters / 4;
    const rate = tokens / seconds;
    return style(`${exact ? '' : '~'}${rate.toFixed(1)} tok/s`, rate < 15) + first;
  }
}
