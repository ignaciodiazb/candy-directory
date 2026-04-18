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

## Rails Conventions

- Always use `bin/rails` (not `rails`) to ensure the app's bundled version of Rails is used
- Always use Rails generators instead of creating files manually:
  - Models: `bin/rails generate model`
  - Controllers: `bin/rails generate controller`
  - Migrations: `bin/rails generate migration`
  - Scaffolds: `bin/rails generate scaffold` (when appropriate)
- Never manually create model, controller, or migration files from scratch
- After generating, customize the output — generators are starting points, not final output
- Always review and edit generated migrations before running `bin/rails db:migrate`

### Strong Parameters

Always use `params.expect` (Rails 8+) instead of `params.require(...).permit(...)`.

**Correct:**
```ruby
def candy_params
  params.expect(candy: [:name, :description, :brand_id])
end
```

**Never use:**
```ruby
def candy_params
  params.require(:candy).permit(:name, :description, :brand_id)
end
```

This applies to all generated controllers, scaffolds, and any manual strong parameter methods.

## Commit messages

Use the [Conventional Commits](https://www.conventionalcommits.org/) standard: `type(scope): description`. Common types: `feat`, `fix`, `refactor`, `test`, `chore`, `docs`.

## Branch names

Follow the same type prefix as conventional commits: `type/short-description`. Examples: `feat/candy-browse-pages`, `fix/slug-collision`, `chore/seed-data`.
