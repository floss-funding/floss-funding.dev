# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions login OAuth buttons" do
  it "renders a POST form to /auth/github with Turbo disabled" do
    get new_session_path
    expect(response).to have_http_status(:ok)

    # Basic presence check for a form that posts to /auth/github
    # We avoid relying on provider mounting; this only inspects the rendered HTML.
    html = response.body
    expect(html).to include("<form")
    expect(html).to include("action=\"/auth/github\"")
    # Rails uses method="post" for form_with method: :post
    expect(html).to include("method=\"post\"")
    # Turbo disabled on the form to allow full-page redirect to provider
    expect(html).to include("data-turbo=\"false\"")
  end
end
