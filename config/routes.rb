Rails.application.routes.draw do
  resources :students
  devise_for :users, controllers: { sessions: 'sessions' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :landing do
    collection do
      get :index
    end
  end

  # resources :user_availabilities, only: [:index, :new, :create, :destroy]
  # routes.rb
  resources :user_availabilities, only: [:index, :create, :destroy] do
    post :toggle, on: :collection
  end

  resources :enrollment_requests, only: [:new, :create, :destroy]
  resources :wizard do
    post :ask, on: :collection
  end

  resources :enrollment_requests do
    post :add_child, on: :collection
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "landing#index"
end
