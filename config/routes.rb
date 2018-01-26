Rails.application.routes.draw do
  root to: 'sessions#new'

  resource :douglass_myers_responses, only: [:new, :create]

  resource :introduction, only: [:show]

  resource :patterson_park_responses, only: [:new, :create]

  resources :sessions, only: [:new, :create]
end
