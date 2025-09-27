return {
	{ -- Lua Development
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			{ "mason-org/mason-lspconfig.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ "j-hui/fidget.nvim", opts = {} },
			{ "saghen/blink.cmp" },
			{
				"jglasovic/venv-lsp.nvim",
				config = function()
					require("venv-lsp").setup()
				end,
			},
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()
			vim.lsp.buf.hover()

			local servers = {
				ruff = {
					init_options = {
						settings = {},
					},
				},
				pyright = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				clangd = {},
				ts_ls = {
					init_options = { hostInfo = "neovim" },
					cmd = { "typescript-language-server", "--stdio" },
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
					},
					root_dir = function(bufnr, on_dir)
						-- The project root is where the LSP can be started from
						-- As stated in the documentation above, this LSP supports monorepos and simple projects.
						-- We select then from the project root, which is identified by the presence of a package
						-- manager lock file.
						local root_markers =
							{ "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
						-- Give the root markers equal priority by wrapping them in a table
						root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
							or vim.list_extend(root_markers, { ".git" })
						-- We fallback to the current working directory if no project root is found
						local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

						on_dir(project_root)
					end,
					handlers = {
						-- handle rename request for certain code actions like extracting functions / types
						["_typescript.rename"] = function(_, result, ctx)
							local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
							vim.lsp.util.show_document({
								uri = result.textDocument.uri,
								range = {
									start = result.position,
									["end"] = result.position,
								},
							}, client.offset_encoding)
							vim.lsp.buf.rename()
							return vim.NIL
						end,
					},
					commands = {
						["editor.action.showReferences"] = function(command, ctx)
							local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
							local file_uri, position, references = unpack(command.arguments)

							local quickfix_items = vim.lsp.util.locations_to_items(references, client.offset_encoding)
							vim.fn.setqflist({}, " ", {
								title = command.title,
								items = quickfix_items,
								context = {
									command = command,
									bufnr = ctx.bufnr,
								},
							})

							vim.lsp.util.show_document({
								uri = file_uri,
								range = {
									start = position,
									["end"] = position,
								},
							}, client.offset_encoding)

							vim.cmd("botright copen")
						end,
					},
					on_attach = function(client, bufnr)
						-- ts_ls provides `source.*` code actions that apply to the whole file. These only appear in
						-- `vim.lsp.buf.code_action()` if specified in `context.only`.
						vim.api.nvim_buf_create_user_command(bufnr, "LspTypescriptSourceAction", function()
							local source_actions = vim.tbl_filter(function(action)
								return vim.startswith(action, "source.")
							end, client.server_capabilities.codeActionProvider.codeActionKinds)

							vim.lsp.buf.code_action({
								context = {
									only = source_actions,
								},
							})
						end, {})
					end,
				},
				html = {
					cmd = { "vscode-html-language-server", "--stdio" },
					filetypes = { "html", "templ" },
					root_markers = { "package.json", ".git" },
					settings = {},
					init_options = {
						provideFormatter = true,
						embeddedLanguages = { css = true, javascript = true },
						configurationSection = { "html", "css", "javascript" },
					},
				},
				cssls = {
					cmd = { "vscode-css-language-server", "--stdio" },
					filetypes = { "css", "scss", "less" },
					init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
					root_markers = { "package.json", ".git" },
					settings = {
						css = { validate = true },
						scss = { validate = true },
						less = { validate = true },
					},
				},
				css_variables = {
					cmd = { "css-variables-language-server", "--stdio" },
					filetypes = { "css", "scss", "less" },
					root_markers = { "package.json", ".git" },
					settings = {
						cssVariables = {
							lookupFiles = { "**/*.less", "**/*.scss", "**/*.sass", "**/*.css" },
							blacklistFolders = {
								"**/.cache",
								"**/.DS_Store",
								"**/.git",
								"**/.hg",
								"**/.next",
								"**/.svn",
								"**/bower_components",
								"**/CVS",
								"**/dist",
								"**/node_modules",
								"**/tests",
								"**/tmp",
							},
						},
					},
				},
				emmet_ls = {
					cmd = { "emmet-ls", "--stdio" },
					filetypes = {
						"astro",
						"css",
						"eruby",
						"html",
						"htmlangular",
						"htmldjango",
						"javascriptreact",
						"less",
						"pug",
						"sass",
						"scss",
						"svelte",
						"templ",
						"typescriptreact",
						"vue",
					},
					root_markers = { ".git" },
				},
			}
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
