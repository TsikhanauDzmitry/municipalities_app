# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  # Defines the root path route ("/")
  root 'pages#home'
  get 'about' => 'pages#about', as: :about_page

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }, path: '', path_names: {
    sign_in: 'login',
    sign_up: 'signup'
  }
  devise_scope(:user) { get '/sign_out' => 'devise/sessions#destroy' }

  # Rotes for ActiveAdmin Dashboard
  ActiveAdmin.routes(self)

  resources :issues do
    member do
      patch :assign_to_self
      patch :update_status
      patch :update_priority
    end
  end
end
