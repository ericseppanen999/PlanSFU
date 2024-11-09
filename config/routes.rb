Rails.application.routes.draw do
  # Root route and Articles
  root "articles#index"
  resources :articles, only: [:index]

  # Courses routes
  resources :courses, only: [] do
    collection do
      get :search_page
      get :search
      get :check_eligibility
    end
  end

  # Users routes
  resources :users, only: [:create, :show, :index] do
    member do
      patch :add_courses
    end
    collection do
      get :test_page
    end
  end

  # Registration routes
  get "/registration", to: "registrations#new", as: :new_registration
  post "/registration", to: "registrations#create"

  # Password reset routes
  resource :password_reset, only: [:new, :create, :edit, :update], controller: :password_resets

  # Session routes
  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  # UserSearchHistory routes
  resources :search_histories, only: [:index]

  # Health check route
  get "/up", to: "rails/health#show", as: :rails_health_check

  # Test route
  get "/test", to: "application#test"

  # PWA files
  get "/service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "/manifest", to: "rails/pwa#manifest", as: :pwa_manifest
end
