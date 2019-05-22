Helpful::Application.routes.draw do
  use_doorkeeper do
    controllers :applications => 'oauth/applications'
  end

  require "sidekiq/web"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end if Rails.env.production?
  mount Sidekiq::Web, at: "/sidekiq"

  get '/styleguide' => 'pages#styleguide', as: :styleguide
  get '/terms' => 'pages#terms', as: :terms
  get '/home' => 'pages#home', as: :home

  # Errors
  get '/404', :to => 'errors#not_found'
  get '/500', :to => 'errors#internal_error'
  get '/422', :to => 'errors#unprocessable_entity'

  devise_for :users, skip: :registrations, :controllers => { :invitations => 'users/invitations' }

  # This is the normal user registrations but NO new/create - That is handled by either:
  # * Account#new (for a new account and the first user)
  devise_scope :user do
    resource :registration,
             only: [:edit, :update, :destroy],
             path: 'users',
             path_names: { new: 'sign_up' },
             controller: 'devise/registrations',
             as: :user_registration do
      get :cancel
    end
  end

  namespace :webhooks do
    resources :mailgun, only: :create
  end

  namespace :api, format: 'json' do
    resources :accounts, except: [:new, :edit, :destroy] do
      resources :conversations, shallow: true, except: [:new, :edit, :destroy] do
        resources :messages, shallow: true, except: [:new, :edit, :destroy] do
          resources :attachments, shallow: true, except: [:new, :edit, :destroy]
        end
      end

      resources :people, shallow: true, except: [:new, :edit, :destroy]
    end
  end

  match '/incoming_message' => 'incoming_messages#create', via: [:get, :post]

  authenticated :user do
    root :to => 'dashboard#show', :as => 'authenticated_root'
    get '/settings' => 'users#edit', as: :edit_user
    resources :users, only: [:update]

    resource :current_user,
             path: '/user',
             only: [:show]
  end

  resource :accounts, only: [:new, :create]

  resources :accounts do
    resources :conversations
  end

  resources :account_emails, only: [:show]

  scope '/:id' do
    resource :account, path: '/', only: [:show, :edit, :update] do
      resources :invitations

      get :demo
      get :setup
      get :web_form
      get :help
    end
  end

  scope '/:account_id', as: :account do
    resources :canned_responses

    resources :conversations, path: '/', only: [:show, :update] do
      get :archived, on: :collection
      get :inbox, on: :collection
      get :search, on: :collection
      get :list, on: :collection

      resources :assignees, only: [:index, :create]
      resources :tags, only: [:index, :create, :destroy]
    end

    resources :messages, only: [:create], shallow: true
  end

  unauthenticated :user do
    root to: 'pages#home'
  end
end
