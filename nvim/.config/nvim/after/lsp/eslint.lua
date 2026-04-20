return {
	filetypes = {
		"html",
		"css",
		"sass",
		"scss",
		"less",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"vue",
		"astro",
		"svelte",
	},
	settings = {
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = "separateLine",
			},
			showDocumentation = {
				enable = true,
			},
		},
		codeActionOnSave = {
			mode = "all",
		},
		format = true,
		nodePath = nil,
		onIgnoredFiles = "off",
		packageManager = "npm",
		problems = {
			shortenToSingleLine = false,
		},
		quiet = false,
		rulesCustomizations = {},
		run = "onType",
		useESLintClass = true,
		validate = "on",
		workingDirectory = {
			mode = "location",
		},
	},
}
