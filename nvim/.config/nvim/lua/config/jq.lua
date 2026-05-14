-- :Jq <filter>     - Pipe buffer (or selection) through jq, replacing contents
-- :JqPeek <filter> - Pipe buffer (or selection) through jq, show output in a scratch split
--
-- Examples:
--   :Jq .                          pretty-print whole buffer in place
--   :Jq .users[0]                  drill into a path, replace buffer
--   :Jq 'map(.name)'               quote when filter has spaces or pipes
--   :Jq '.items | length'          shell-style pipes inside the filter
--   :JqPeek .                      pretty-print into a side scratch buffer
--   :JqPeek 'keys'                 list top-level keys without touching buffer
--   :'<,'>JqPeek .                 run on visual selection only
--   :5,20Jq .                      run on a line range
vim.api.nvim_create_user_command("Jq", function(opts)
	vim.cmd(string.format("%d,%d!jq %s", opts.line1, opts.line2, opts.args))
end, { range = "%", nargs = "+" })

vim.api.nvim_create_user_command("JqPeek", function(opts)
	local input = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
	local result = vim.fn.systemlist({ "jq", opts.args }, input)
	if vim.v.shell_error ~= 0 then
		vim.notify(table.concat(result, "\n"), vim.log.levels.ERROR)
		return
	end
	vim.cmd("vnew")
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false
	vim.bo.filetype = "json"
	vim.api.nvim_buf_set_lines(0, 0, -1, false, result)
end, { range = "%", nargs = "+" })
