# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'current_user', to: 'current_user#index'
      post 'users/sign_in', to: 'sessions#create'
      delete 'users/sign_out', to: 'sessions#destroy'

      namespace :admin do
        resources :recipes, only: [:create, :update, :destroy]
        resources :glasses, only: [:create, :update, :destroy]
        resources :ingredients
      end
    end
  end

  get '/health_check', to: proc { [200, {}, ['success']] }
end
