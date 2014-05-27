Rails.application.routes.draw do
  resources :events
  resources :seasons

  if Rails.env.production?
    scope :protocol => 'https://', :constraints => { :protocol => 'https://' } do
      devise_for :users, skip: [:registrations],
        controllers: {omniauth_callbacks: 'users/omniauth_callbacks',
                      invitations: 'users/invitations'}
      as :user do
        get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
        put 'users' => 'devise/registrations#update', :as => 'user_registration'
      end
    end
  else
    devise_for :users, skip: [:registrations],
      controllers: {omniauth_callbacks: 'users/omniauth_callbacks',
                    invitations: 'users/invitations'}

    as :user do
      get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
      put 'users' => 'devise/registrations#update', :as => 'user_registration'
    end
  end

  authenticated :user do
    root :to => 'events#index', :as => :authenticated_root
  end
  root :to => redirect('/users/sign_in')

  get 'feed/:token' => 'events#feed'
end
