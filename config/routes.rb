# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  #   authenticate :user do
  #     mount Sidekiq::Web => 'admins/sidekiq'
  #   end

  mount Sidekiq::Web => '/sidekiq'

  root 'calculators#index'
  get '/calculator', to: 'calculators#calculator'
  post '/receive_recomendations', to: 'calculators#receive_recomendations'
  get '/about_us', to: redirect('/about_us.html')

  devise_for :users, controllers: { registrations: 'users/registrations',
                                    omniauth_callbacks:
                                    'users/omniauth_callbacks' }
  resources :calculators, only: %i[index show], param: :slug do
    member do
      post :calculate
    end
  end
  resources :messages, only: %i[new create]
  resources :locales, only: :update, constraints: { id: /(en|uk)/ }
  namespace :admins do
    resources :users, only: %i[index show edit update]
    resources :calculators, param: :slug
    resources :histories, only: :index
    resources :messages, only: %i[index show]
    resource :app_config, only: %i[edit update]

    scope module: :calculators do
      resources :calculators, only: [], param: :slug do
        resources :fields, only: :new
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :calculators, only: [] do
        post :compute, on: :member
      end
      resource :diaper_calculators, only: %i[create]
    end
    namespace :v2 do
      resources :calculators, only: [] do
        post :compute, on: :member
      end
    end
  end
end
