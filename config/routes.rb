# frozen_string_literal: true

Rails.application.routes.draw do
  # Routes for the Business model
  resources :businesses, only: %i[create index] do
    get :order_history, on: :member, as: :order_history
    # Nested routes for orders related to a specific business
    resources :orders, only: %i[index create]
  end

  # Routes for the Order model
  resources :orders, only: %i[show update] do
    member do
      patch 'accept' # action to accept an order
      patch 'reject' # action to reject an order
    end
  end

  # Defines the root path route ("/")
  # root "articles#index"
end
