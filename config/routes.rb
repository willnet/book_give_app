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

  #static_pagesコントローラの部分
  root "static_pages#top"
  get '/contact', to: 'static_pages#contact'
  get '/how_to_use', to: "static_pages#how_to_use"
  get '/privacy', to: "static_pages#privacy"

end
