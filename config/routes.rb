Rails.application.routes.draw do

  #deviseのコントローラをgしたときに追加した記述
  # 参考: https://remonote.jp/rails_devise_after_sign_up
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions',
    :passwords => 'users/passwords'
  }

  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end

  resources :users
  get '/users/:id/registered',to: 'users#registered', as: 'user_registered'
  get '/users/:id/history', to: "users#history", as: 'user_history'
  get '/users/:id/offered', to: "users#offered", as: 'user_offered'

  #static_pagesコントローラの部分
  root "static_pages#top"
  get '/contact', to: 'static_pages#contact'
  get '/how_to_use', to: "static_pages#how_to_use"
  get '/privacy', to: "static_pages#privacy"

  #bookコントローラの部分
  post 'book/:id/destroy', to: 'book#destroy'
  get 'book/search_results'
  get 'book/send_offer'
  get 'book/offer_success'
  get 'book/new_give'
  get 'book/give_confirmation'
  get '/book/:id/message' => "book#message"
  resources :book

  #開発環境でletter_opener_webを使うための記述
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

end
