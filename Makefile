.PHONY: help test lint docs check clean

help:
	@echo "Available commands:"
	@echo "  make test  - Run Helm unit tests"
	@echo "  make lint  - Lint Helm chart"
	@echo "  make docs  - Generate README documentation"
	@echo "  make check - Run all checks (lint + test + docs)"

test:
	@echo "🧪 Running tests..."
	@cd charts/notes-app && helm unittest .

lint:
	@echo "🔍 Linting chart..."
	@cd charts/notes-app && helm lint .

docs:
	@echo "📝 Generating docs with helm-docs..."
	@cd charts/notes-app && helm-docs --output-file ../../README.md
	@echo "✅ Documentation generated in README.md"

check: lint test docs
	@echo "✅ All checks passed!"

clean:
	@cd charts/notes-app && rm -f *.tgz
