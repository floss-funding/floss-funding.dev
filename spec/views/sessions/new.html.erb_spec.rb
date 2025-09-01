# frozen_string_literal: true

require "rails_helper"

RSpec.describe "sessions/new.html.erb" do
  it "includes a POST form to /auth/github with Turbo disabled" do
    render
    expect(rendered).to include("<form")
    expect(rendered).to include("action=\"/auth/github\"")
    expect(rendered).to include("method=\"post\"")
    expect(rendered).to include("data-turbo=\"false\"")
  end
end
