.PHONY: help test lint docs check clean

help:
	@echo "Available commands:"
	@echo "  make test  - Run Helm unit tests"
	@echo "  make lint  - Lint Helm chart"
	@echo "  make docs  - Generate README documentation"
	@echo "  make check - Run all checks (lint + test + docs)"

test:
	@echo "🧪 Running tests..."
	@helm unittest .

lint:
	@echo "🔍 Linting chart..."
	@helm lint .

docs:
	@echo "📝 Generating docs..."
	@helm-docs

check: lint test docs
	@echo "✅ All checks passed!"

clean:
	@rm -f *.tgz