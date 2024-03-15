# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  scope :api do
    scope :v1 do
      post "safeboxes", to: "safe_ish/safeboxes/api/v1/create_safebox#create", as: :create_safebox
      post "safeboxes/:id/open", to: "safe_ish/safeboxes/api/v1/open_safebox#create", as: :open_safebox
      get "safeboxes/:id/items", to: "safe_ish/safeboxes/api/v1/list_safebox_items#index", as: :list_safebox_items
      post "safeboxes/:id/items", to: "safe_ish/safeboxes/api/v1/add_safebox_item#create", as: :add_safebox_item
    end
  end
end
