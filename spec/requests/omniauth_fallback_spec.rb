# frozen_string_literal: true

require "rails_helper"

RSpec.describe "OmniAuth fallback initiation handlers" do
  include_context "with stubbed env"

  before do
    # Ensure provider is considered not configured
    stub_env(
      "GITHUB_CLIENT_ID" => nil,
      "GITHUB_CLIENT_SECRET" => nil,
      "GITLAB_CLIENT_ID" => nil,
      "GITLAB_CLIENT_SECRET" => nil,
      "CODEBERG_CLIENT_ID" => nil,
      "CODEBERG_CLIENT_SECRET" => nil,
    )
  end

  it "redirects POST /auth/github to login with an informative alert when not configured" do
    post "/auth/github"
    expect(response).to have_http_status(:redirect)
    expect(response.headers["Location"]).to include(new_session_path)
    expect(response.headers["Location"]).to include("not+configured")
  end

  it "redirects GET /auth/github to login with guidance and does not start OAuth" do
    get "/auth/github"
    expect(response).to have_http_status(:redirect)
    expect(response.headers["Location"]).to include(new_session_path)
    expect(response.headers["Location"]).to include("Please+use+the+Sign+in+button")
  end
end
