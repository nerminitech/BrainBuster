Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#landing"
  get "hilfe", to: "pages#help", as: :help
  get "dashboard", to: "pages#home"

  resources :categories, only: %i[index show]

  resources :matches do
    collection do
      post :join
    end

    member do
      get :play
    end

    resources :attempts, only: :create, module: :matches
  end

  resources :leaderboards, only: :index

  namespace :admin do
    resources :categories
    resources :questions
  end
end
