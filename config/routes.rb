Rails.application.routes.draw do
  root 'home#index'

  devise_for :users

  get '/dashboard', to: 'dashboards#index'
  get '/dashboard/stats', to: 'dashboards#stats'

  resources :tasks do
    collection do
      get 'today'
    end
    member do
      patch 'complete'
    end
    resources :collaborators, only: [:new, :create]
  end

  resources :dashboards, only: [:index]
end
