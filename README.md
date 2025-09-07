# floss-funding.dev

This repository is a Rails 8 application. Below are instructions for local development, including how TailwindCSS is rebuilt automatically as you work.

## Requirements
- Ruby (see `.ruby-version` if present or use the version from Gemfile)
- Bundler
- SQLite3 (for development/test)

## Setup
```
bundle install
bin/rails db:setup
```

## Running the app
Recommended: run the dev Procfile (starts Rails + Tailwind watcher):
```
bin/dev
```
If you prefer to run Rails directly, you must also run the Tailwind watcher in another terminal, otherwise CSS may look broken locally:
```
# Terminal 1
bin/rails server
# Terminal 2
bin/rails tailwindcss:watch
```
You can also do a one-off Tailwind build at any time:
```
bin/rake tailwindcss:build
```

## Auto-building TailwindCSS during development
We provide two ways to keep your Tailwind styles up-to-date while you edit files.

### Option A: Procfile.dev (Tailwind watcher)
A Procfile is included with a Tailwind watcher process.

- Install a Procfile runner (choose one):
  - foreman: `gem install foreman`
  - or overmind: https://github.com/DarthSim/overmind
- Start the dev processes (web + Tailwind watcher):
```
foreman start -f Procfile.dev
# or with Overmind
overmind start -f Procfile.dev
```
This runs `bin/rails tailwindcss:watch`, which continuously rebuilds CSS.

### Option B: Guard (runs bin/rake tailwindcss:build on changes)
If you prefer to trigger a one-off Tailwind build automatically whenever files change, use Guard:

1) Ensure development dependencies are installed:
```
bundle install
```
2) Start Guard:
```
bundle exec(guard)
```
Guard will watch:
- app/assets/stylesheets/**/*
- app/javascript/**/*
- app/views/**/*
- app/helpers/**/*
- app/components/**/*
- config/**/*
- tailwind.config.* (if present)

When any of these files change, Guard runs:
```
bin/rake tailwindcss:build
```
This will regenerate CSS into the propshaft builds directory.

Tip: On a brand new clone, you can prime the build once with:
```
bin/rake tailwindcss:build
```

## Running tests
```
bundle exec(rspec)
```

## OAuth setup (GitHub)
When creating a GitHub OAuth App for this project, use the following Authorization callback URL based on environment:

- QA (fly.io): https://floss-funding-qa.fly.dev/auth/github/callback

Notes:
- The OmniAuth callback route is defined as `/auth/:provider/callback` (see config/routes.rb). For GitHub specifically, that is `/auth/github/callback`.
- Ensure you set `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` in your runtime environment. For local development, set these in `.env.local` (see `.env.local.example`) and/or `.envrc`.
- For QA deploys (Fly.io via GitHub Actions), GitHub forbids repository secret names starting with `GITHUB_`. Create repository secrets named `GH_OAUTH_CLIENT_ID` and `GH_OAUTH_CLIENT_SECRET` instead. The workflow `.github/workflows/fly-deploy.yml` reads those and sets Fly app secrets named `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` accordingly on deploy.

## Notes
- Tailwind is integrated via the `tailwindcss-rails` gem.
- You can use either Option A (continuous watcher) or Option B (Guard-triggered builds). Use the one that best fits your workflow.
