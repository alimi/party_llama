Rails.application.routes.draw do
  resources :party_responses, only: [:new, :create]
end
