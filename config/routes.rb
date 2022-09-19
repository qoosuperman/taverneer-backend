# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'current_user', to: 'current_user#index'
      post 'users/sign_in', to: 'sessions#create'
      delete 'users/sign_out', to: 'sessions#destroy'
    end
  end
end
