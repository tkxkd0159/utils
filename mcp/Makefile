.Phony: dockerbuild/weather tidy

tidy:
	@uv sync
	@uv run ruff check --fix
	@uv run ruff format

dockerbuild/weather:
	@podman build -t mcp-weather ./weather