FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app

# Copy dependency files first for better caching
COPY pyproject.toml uv.lock ./

# Install dependencies (production only)
RUN uv sync --frozen --no-dev --no-install-project

# Copy application code
COPY weather.py ./

# Install the project itself
RUN uv sync --frozen --no-dev

# Run the MCP server (uses stdio transport)
CMD ["uv", "run", "--no-sync", "weather.py"]
