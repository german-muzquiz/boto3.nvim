.DEFAULT_GOAL = check

lint:
	@luacheck lua/nvim-boto3/
	@luacheck tests/

format:
	@stylua --config-path=.stylua.toml lua/

precommit_check: format test lint

check: lint test
