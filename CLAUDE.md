# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
bin/setup          # First-time setup: install gems, prepare database
bin/dev            # Start development server (port 3000)
bin/ci             # Full CI pipeline: setup, lint, security scans, tests
bin/rails test     # Run all tests
bin/rails test test/path/to/specific_test.rb  # Run a single test file
bin/rails test:system  # Run system tests (Capybara + Selenium)
bin/rubocop        # Lint Ruby code
bin/brakeman       # Rails security analysis
bin/bundler-audit  # Scan gems for known vulnerabilities
```

## Architecture

Rails 8.1.2 app with SQLite, Hotwire (Turbo + Stimulus), and Propshaft assets. No Node.js build step — JavaScript is managed via ImportMap.

**Database-backed infrastructure** (all via SQLite, separate files per concern):
- Jobs: Solid Queue (runs inside Puma via `SOLID_QUEUE_IN_PUMA=true` for single-server; `bin/jobs` for separate process)
- Cache: Solid Cache
- WebSockets: Solid Cable

**Deployment**: Docker + Kamal. The `config/deploy.yml` targets a single server with a local Docker registry.

**CI pipeline** (`config/ci.rb`): setup → rubocop → bundler-audit → importmap audit → brakeman → `rails test`. System tests are available but commented out.

**Frontend**: Hotwire (Turbo + Stimulus). Stimulus controllers live in `app/javascript/controllers/`. Assets handled by Propshaft (no preprocessing).

**Testing**: Minitest with parallel workers. System tests use Capybara + Selenium.

**Style**: RuboCop with `rubocop-rails-omakase` (Omakase defaults, minimal custom config in `.rubocop.yml`).

## Commit messages

Use the [Conventional Commits](https://www.conventionalcommits.org/) standard: `type(scope): description`. Common types: `feat`, `fix`, `refactor`, `test`, `chore`, `docs`.
