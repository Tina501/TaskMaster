Rails.application.routes.draw do
  root 'home#index'

  devise_for :users

  get '/dashboard', to: 'dashboards#index'
  get '/dashboard/stats', to: 'dashboards#stats'
  get '/users/search', to: 'users#search', as: :search_users

  resources :tasks do
    collection do
      get 'today'
    end
    member do
      patch 'complete'
      patch :toggle
    end
    resources :collaborators, only: [:new, :create]
    resources :sub_tasks do
      member do
        patch :toggle
      end
    end
  end

  resources :dashboards, only: [:index]
end
