# frozen_string_literal: true

require "omniauth-oauth2"

module OmniAuth
  module Strategies
    # Minimal OAuth2 strategy for GitHub
    class Github < OmniAuth::Strategies::OAuth2
      option :name, "github"

      option :client_options, {
        site: "https://github.com",
        authorize_url: "/login/oauth/authorize",
        token_url: "/login/oauth/access_token",
      }

      # Request email access to fetch primary email if needed
      option :scope, "user:email"

      uid { raw_info["id"].to_s }

      info do
        {
          name: raw_info["name"].presence || raw_info["login"],
          email: primary_email_from_api || raw_info["email"],
          nickname: raw_info["login"],
          image: raw_info["avatar_url"],
          urls: {
            profile: raw_info["html_url"] || (raw_info["login"] && "https://github.com/#{raw_info["login"]}"),
          },
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= oauth_api_get("/user") || {}
      end

      # GitHub user/email API lives on api.github.com; OAuth site is github.com
      def oauth_api_get(path)
        access_token.get("https://api.github.com#{path}").parsed
      end

      def primary_email_from_api
        emails = oauth_api_get("/user/emails")
        return nil unless emails.is_a?(Array)
        primary = emails.find { |e| e["primary"] } || emails.find { |e| e["verified"] }
        (primary && primary["email"]) || nil
      rescue StandardError
        nil
      end
    end
  end
end
