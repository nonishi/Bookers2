Rails.application.routes.draw do
  devise_for :users

  root to: 'homes#top'
  get 'home/about' => 'homes#about', as: :homes_about

  get '/search' => 'searches#search'

  resources :books, except: [:new] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    get "search", to: "users#search"
  end

  resources :groups do
    get "join" => "groups#join"
    get "new/mail" => "groups#new_mail"
    get "send/mail" => "groups#send_mail"
  end

  resources :chats, only: [:show, :create]

end
