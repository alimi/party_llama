Rails.application.routes.draw do
  root to: 'sessions#new'

  resource :conclusion, only: [:show]

  resource :douglass_myers_responses, only: [:new, :create]

  resource :introduction, only: [:show]

  resources :party_responses, only: [:index]

  resources :party_response_submissions, only: [:create]

  resource :patterson_park_responses, only: [:new, :create]

  resources :sessions, only: [:new, :create]

  resources :session_verifications, only: [:new, :create]

  namespace :admin do
    root to: 'parties#index'

    resources :parties, only: [:index, :show, :new, :create, :edit, :update] do
      resources :guests, only: [:index, :new, :create, :edit, :update]
    end
  end

  namespace :voice, path: "/voice/(:locale)" do
    resource :introduction, only: [:show]

    scope "/:venue", constraints: VenueConstraint.new do
      resources :guest_responses, only: [:new, :create]

      resources :guest_response_confirmations, only: [:new, :create]

      resources :party_responses, only: [:new, :create]
    end

    resources :sessions, only: [:new, :create]

    resources :session_verifications, only: [:new, :create]
  end
end
