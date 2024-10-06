Rails.application.routes.draw do
  get "/articles", to: "articles#index"
  get "/courses/search_page", to: "courses#search_page"


  # Route to handle the search request from the front end
  get "/courses/search", to: "courses#search"

  # Route for CAS login
  # get "/login", to: "cas_sessions#new", as: :login

  # Route for CAS logout
  # delete "/logout", to: "cas_sessions#destroy", as: :logout

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # get "/cas_sessions/new", to: "cas_sessions#new", as: :login # Route to initiate CAS login
  # get "/cas_sessions/create", to: "cas_sessions#create"       # CAS callback after login
  # delete "/cas_sessions/destroy", to: "cas_sessions#destroy", as: :logout

  # UserSearchHistory routes
  resources :search_histories, only: [ :index ]

  resources :users, only: [ :show, :edit, :update, :destroy ]
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.


  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
