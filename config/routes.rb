# frozen_string_literal: true

Rails.application.routes.draw do
  resources :events
  resources :seasons
  resources :notifications, only: %i[new create]

  devise_for :users, skip: [:registrations],
                     controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    invitations: 'users/invitations' }

  post '/dev_login', to: 'dev_login#create', as: 'dev_login' if Rails.env.development?

  as :user do
    get 'users/edit' => 'users/registrations#edit', as: 'edit_user_registration'
    put 'users' => 'users/registrations#update', as: 'user_registration'
    as :invitation do
      devise_scope :user do
        get 'users/invitation/grant' => 'users/invitations#to_grant', as: 'to_grant_invitations'
        post 'users/invitation/grant' => 'users/invitations#grant', as: 'grant_invitations'
      end
    end
  end

  authenticated :user do
    root to: 'events#index', as: :authenticated_root
  end
  root to: redirect('/users/sign_in')

  # ics feed
  get 'feed/:token' => 'events#feed', as: 'events_feed'

  # Twilio route
  post 'voice/events' => 'voice#events', defaults: { format: 'xml' }

  # Static pages
  PagesController.action_methods.each do |action|
    get "/#{action}", to: "pages##{action}", as: "#{action}_page"
  end

  get '/manifest', to: 'rails/pwa#manifest', as: 'pwa_manifest'
end
