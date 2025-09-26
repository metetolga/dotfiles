if vim.g.vscode then
	require("config.vscode")
else
	require("config.general")
	require("config.lazy")
end
