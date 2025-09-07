require "rails_helper"

RSpec.describe "ActivationKeys", type: :request do
  let!(:account) { Account.create!(email: "user@example.com") }
  let!(:identity) { Identity.create!(account: account, email: account.email, password: "secret123", password_confirmation: "secret123") }

  before do
    # Log in via sessions controller
    post session_path, params: {email: account.email, password: "secret123"}
  end

  it "lists activation keys and allows creating new key" do
    get activation_keys_path
    expect(response).to have_http_status(:ok)

    post activation_keys_path, params: {activation_key: {library_name: "Lib", namespace: "org", key: "lib", ecosystem: "ruby", project_name: "Proj", featured: "1"}}
    expect(response).to redirect_to(activation_keys_path)

    follow_redirect!
    expect(response.body).to include("org/lib")
    expect(ActivationKey.last).to be_featured
  end

  it "filters by search query and filters by one or more languages" do
    # Create a few keys across ecosystems
    ActivationKey.create!(library_name: "Alpha", namespace: "aaa", key: "bbb", ecosystem: "ruby")
    ActivationKey.create!(library_name: "Zeta", namespace: "zzz", key: "yyy", ecosystem: "python")
    ActivationKey.create!(library_name: "Beta", namespace: "bbb", key: "alpha", ecosystem: "javascript")

    # Search for 'bbb' should include two results and exclude the python one with 'zzz/yyy'
    get activation_keys_path, params: {q: "bbb"}
    expect(response).to have_http_status(:ok)
    body = response.body
    expect(body).to include("aaa/bbb")
    expect(body).to include("bbb/alpha")
    expect(body).not_to include("zzz/yyy")

    # Filter by a single language (javascript)
    get activation_keys_path, params: {ecosystems: ["javascript"]}
    body = response.body
    expect(body).to include("bbb/alpha")
    expect(body).not_to include("aaa/bbb")
    expect(body).not_to include("zzz/yyy")

    # Filter by multiple languages (javascript and ruby)
    get activation_keys_path, params: {ecosystems: ["javascript", "ruby"]}
    body = response.body
    expect(body).to include("bbb/alpha")
    expect(body).to include("aaa/bbb")
    expect(body).not_to include("zzz/yyy")
  end

  it "sorts old to new when requested" do
    ActivationKey.create!(library_name: "Lib1", namespace: "ns1", key: "key1", ecosystem: "ruby", created_at: 2.days.ago)
    ActivationKey.create!(library_name: "Lib2", namespace: "ns2", key: "key2", ecosystem: "ruby", created_at: 1.day.ago)

    get activation_keys_path, params: {sort: "old"}
    body = response.body
    first_index = body.index("ns1/key1")
    second_index = body.index("ns2/key2")
    expect(first_index).to be < second_index
  end
end
