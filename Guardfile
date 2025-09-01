# Guardfile for automatic Tailwind CSS builds and Rails server management
# - Runs `rake tailwindcss:build` whenever relevant files change.
# - Starts the Rails server and restarts it as needed when files change.
# Requires gems: guard, guard-rake, guard-rails (added in Gemfile under development group).

# Rails server management
# Options:
#  - start_on_start: start server when Guard starts
#  - force_run: kill any existing server on the same port and re-run
#  - environment: use development by default
#  - server: use Puma explicitly
#  - port: default to 3000 (can be overridden via ENV["PORT"])
port = (ENV["PORT"] || "3000").to_i

guard :rails, port: port, environment: ENV["RAILS_ENV"] || "development", start_on_start: true, force_run: true do
  # Common triggers for server restart
  watch("Gemfile.lock")
  watch(%r{^config/(application|routes|environments)/.*\.rb$})
  watch(%r{^config/initializers/.*\.rb$})
  watch(%r{^config/locales/.*\.(yml|rb)$})
  watch(%r{^lib/.*\.rb$})
  watch(%r{^app/(controllers|models|helpers|mailers|jobs|channels)/.*\.rb$})
  watch(%r{^app/views/.*\.(erb|haml|slim)$})
end

# Tailwind CSS build automation
guard :rake, task: "tailwindcss:build" do
  # Stylesheets (including tailwind entry file)
  watch(%r{^app/assets/stylesheets/.+\.(css|scss|sass)$})
  # Tailwind v4 canonical entry directory
  watch(%r{^app/assets/tailwind/.+\.(css)$})

  # JavaScript/TypeScript (class names may affect Tailwind purge)
  watch(%r{^app/javascript/.+\.(js|mjs|ts|tsx)$})

  # Views and partials (class names here affect Tailwind)
  watch(%r{^app/views/.+\.(erb|haml|slim)$})

  # Helpers and Ruby view components
  watch(%r{^app/helpers/.+\.rb$})
  watch(%r{^app/components/.+\.(rb|erb|haml|slim)$})

  # Configuration changes that may influence assets
  watch(%r{^config/.+\.(rb|yml)$})

  # Tailwind config (if present in project)
  watch("tailwind.config.js")
  watch("tailwind.config.cjs")
  watch("tailwind.config.ts")
end
