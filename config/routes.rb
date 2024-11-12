Rails.application.routes.draw do
  # Root route
  root "articles#index"

  scope module: :web do
    get 'registration', to: 'registrations#new', as: :signup
    post 'registration', to: 'registrations#create'
    get 'login', to: 'sessions#new', as: :login
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy', as: :logout
  end

  # API authentication routes
  namespace :api do
    post 'auth/login', to: 'auth#login'
    post 'auth/signup', to: 'auth#signup'
    delete 'auth/logout', to: 'auth#logout'
  end

  # Course functionality
  resources :courses, only: [] do
    collection do
      get :search_page
      get :search
      get :check_eligibility
    end
  end

  # User functionality
  resources :users, only: [:create, :show] do
    member do
      patch :add_courses
    end
  end

  

  # Search history
  resources :search_histories, only: [:index]

  # PWA routes
  get "/service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "/manifest", to: "rails/pwa#manifest", as: :pwa_manifest
  
  # Health check
  get "/up", to: "rails/health#show", as: :rails_health_check
end