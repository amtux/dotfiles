/**
 * /exit alias for /quit
 *
 * Habit from other harnesses: typing /exit should leave pi cleanly.
 * Pi has no built-in slash-command alias setting, so this registers an
 * "exit" command that does what the built-in /quit does: ctx.shutdown().
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	pi.registerCommand("exit", {
		description: "Exit pi cleanly (alias for /quit)",
		handler: async (_args, ctx) => {
			ctx.shutdown();
		},
	});
}
