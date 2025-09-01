# frozen_string_literal: true

require "rails_helper"

RSpec.describe "sessions/new.html.erb" do
  before do
    # Avoid asset pipeline dependency in view specs when rendering the layout
    allow(view).to receive_messages(
      stylesheet_link_tag: "",
      javascript_importmap_tags: "",
      lucide_icon: "",
    )
    allow(Sentry).to receive(:get_trace_propagation_meta).and_return("")
    view.define_singleton_method(:current_account) { nil }
  end

  it "renders flash alert in the layout as a visible notification" do
    flash.now[:alert] = "Something went wrong"
    render template: "sessions/new", layout: "layouts/application"
    expect(rendered).to include("Something went wrong")
    # Tailwind classes for alert styling should be present
    expect(rendered).to include("bg-red-50")
  end

  it "renders flash notice in the layout as a visible notification" do
    flash.now[:notice] = "All good"
    render template: "sessions/new", layout: "layouts/application"
    expect(rendered).to include("All good")
    expect(rendered).to include("bg-green-50")
  end
end
