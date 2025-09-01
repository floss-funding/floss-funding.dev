Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Favicon: redirect legacy /favicon.ico requests to our SVG logo
  get "/favicon.ico", to: redirect("/logo-blank.svg")

  # Auth
  resource :session, only: [:new, :create, :destroy]
  # OmniAuth callbacks
  match "/auth/:provider/callback", to: "sessions#omniauth", via: [:get, :post] # rubocop:disable Betterment/NonStandardActions
  match "/auth/failure", to: "sessions#failure", via: [:get, :post] # rubocop:disable Betterment/NonStandardActions

  resources :accounts, only: [:new, :create]

  # Password resets
  resources :password_resets, only: [:new, :create], path: "password_resets"
  get "password_resets/:token/edit", to: "password_resets#edit", as: :edit_password_reset
  patch "password_resets/:token", to: "password_resets#update", as: :password_reset

  # Activation keys
  resources :activation_keys, only: [:index, :new, :create, :show, :edit, :update]
  resources :retired_activation_keys, only: [:index]

  # Index lists
  resources :projects, only: [:index, :show]
  resources :libraries, only: [:index, :show]
  resources :namespaces, only: [:index, :show]

  # Static pages
  get "about" => "welcome#about", :as => :about

  # Defines the root path route ("/")
  root "welcome#index"
end
