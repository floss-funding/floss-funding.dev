OmniAuth.config.logger = Rails.logger

# Enforce POST for /auth requests and add CSRF protection for OmniAuth
OmniAuth.config.allowed_request_methods = [:post]

# Load custom strategies
require "omniauth/strategies/github"
require "omniauth/strategies/codeberg"
require "omniauth/strategies/gitlab"

# Determine which providers are configured at boot and expose via Rails.configuration.x
github_enabled = ENV["GITHUB_CLIENT_ID"].present? && ENV["GITHUB_CLIENT_SECRET"].present?
gitlab_enabled = ENV["GITLAB_CLIENT_ID"].present? && ENV["GITLAB_CLIENT_SECRET"].present?
codeberg_enabled = ENV["CODEBERG_CLIENT_ID"].present? && ENV["CODEBERG_CLIENT_SECRET"].present?

Rails.configuration.x.oauth_providers = {
  "github" => github_enabled,
  "gitlab" => gitlab_enabled,
  "codeberg" => codeberg_enabled,
}

any_enabled = github_enabled || gitlab_enabled || codeberg_enabled

if any_enabled
  Rails.application.config.middleware.use(OmniAuth::Builder) do
    # Password identity (only needed when OmniAuth is mounted for external providers)
    provider :identity,
      fields: [:email],
      model: Identity,
      on_failed_registration: lambda { |env|
        SessionsController.action(:new).call(env)
      }

    # GitHub OAuth
    if github_enabled
      provider :github,
        ENV["GITHUB_CLIENT_ID"],
        ENV["GITHUB_CLIENT_SECRET"],
        scope: "user:email",
        provider_ignores_state: false
    end

    # GitLab OAuth
    if gitlab_enabled
      gitlab_site = ENV["GITLAB_SITE"].presence || "https://gitlab.com"
      provider :gitlab,
        ENV["GITLAB_CLIENT_ID"],
        ENV["GITLAB_CLIENT_SECRET"],
        client_options: {site: gitlab_site},
        scope: "read_user",
        provider_ignores_state: false
    end

    # Codeberg OAuth (custom strategy)
    if codeberg_enabled
      provider :codeberg,
        ENV["CODEBERG_CLIENT_ID"],
        ENV["CODEBERG_CLIENT_SECRET"],
        scope: "read:user",
        client_options: {
          site: ENV["CODEBERG_SITE"].presence || "https://codeberg.org",
        },
        provider_ignores_state: false
    end
  end
end
