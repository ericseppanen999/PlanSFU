Rails.application.routes.draw do
  # Articles routes
  get "/articles", to: "articles#index"

  root "articles#index"

  # Courses routes
  get "/courses/search_page", to: "courses#search_page"
  get "/courses/search", to: "courses#search"
  get "/users/test_page", to: "users#test_page"
  get "courses/check_eligibility", to: "courses#check_eligibility"

resource :registration
resource :password_reset
resource :password
resource :session, only: [ :new, :create, :destroy ]


  # UserSearchHistory routes
  resources :search_histories, only: [ :index ]

  # User routes
  resources :users, only: [ :create, :show, :index ] do
    member do
      patch "add_courses", to: "users#add_courses"
    end
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
