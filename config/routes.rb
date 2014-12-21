Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with 'rake routes'.

  require File.expand_path('../../lib/logged_in_constraint', __FILE__)

  root to: 'games#index', constraints: LoggedInConstraint.new(true), as: :authenticated_root
  root to: 'home#index', constraints: LoggedInConstraint.new(false)


  get 'sign_in' => 'sessions#new', as: 'sign_in'
  get 'sign_out' => 'sessions#destroy', as: 'sign_out'
  get 'sign_up' => 'users#new', as: 'sign_up'

  resources :users, only: [:new, :create]
  resources :ships, only: [:new, :create]

  resources :sessions, only: [:create]
end
