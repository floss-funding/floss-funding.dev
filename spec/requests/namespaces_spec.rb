# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Namespaces" do
  describe "GET /namespaces" do
    it "renders the index" do
      Namespace.create!(name: "Alpha", ecosystem: "ruby")
      Namespace.create!(name: "Beta", ecosystem: "ruby")

      get namespaces_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Namespaces").or include("Namespace")
    end

    it "filters by q param" do
      Namespace.create!(name: "Alpha", ecosystem: "ruby")
      Namespace.create!(name: "Zeta", ecosystem: "ruby")

      get namespaces_path(q: "alp")
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Alpha")
      expect(response.body).not_to include("Zeta")
    end
  end

  describe "GET /namespaces/:id" do
    it "renders the show" do
      ns = Namespace.create!(name: "Acme", ecosystem: "ruby")
      get namespace_path(ns)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Acme").or include("Namespace")
    end
  end
end
