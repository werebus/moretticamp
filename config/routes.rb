# frozen_string_literal: true

Rails.application.routes.draw do
  resources :events
  resources :seasons

  devise_for :users,
             skip:        [:registrations],
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                            invitations:        'users/invitations' }

  as :user do
    get 'users/edit' => 'users/registrations#edit',
        as: 'edit_user_registration'
    put 'users' => 'users/registrations#update',
        as: 'user_registration'
  end

  authenticated :user do
    root to: 'events#index', as: :authenticated_root
  end
  root to: redirect('/users/sign_in')

  # ics feed
  get 'feed/:token' => 'events#feed', as: 'events_feed'

  # Twilio route
  post 'voice/events' => 'voice#events'

  resources :notifications, only: %i[new create]

  # Static pages
  PagesController.action_methods.each do |action|
    get "/#{action}", to: "pages##{action}", as: "#{action}_page"
  end
end
