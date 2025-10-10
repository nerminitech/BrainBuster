Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#landing"
  get "hilfe", to: "pages#help", as: :help
  get "dashboard", to: "pages#home"

  resource :profile, only: %i[show edit update]

  resources :categories, only: %i[index show]

  resources :matches do
    collection do
      post :join
    end

    member do
      get :play
      get :status
    end

    resources :attempts, only: :create, module: :matches
  end

  resources :leaderboards, only: :index
  resources :achievements, only: :index

  namespace :admin do
    resources :categories do
      resources :questions, only: :create, module: :categories
    end
    resources :questions
    resource :seed, only: :create, controller: :seed
  end
end
