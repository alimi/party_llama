Rails.application.routes.draw do
  root to: 'sessions#new'

  resource :conclusion, only: [:show]

  resource :douglass_myers_responses, only: [:new, :create]

  resource :introduction, only: [:show]

  resources :party_responses, only: [:index]

  resources :party_response_submissions, only: [:create]

  resource :patterson_park_responses, only: [:new, :create]

  resources :sessions, only: [:new, :create]

  namespace :voice do
    resources :patterson_park_responses, only: [:new, :create]

    resources :patterson_park_guest_responses, only: [:new, :create]

    resources :sessions, only: [:new, :create] do
      resources :verifications, only: [:new, :create]
    end
  end
end
