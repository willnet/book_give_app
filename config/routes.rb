Rails.application.routes.draw do
  #static_pagesコントローラの部分
  root "static_pages#top"
  get '/contact', to: 'static_pages#contact'
  get '/how_to_use', to: "static_pages#how_to_use"
  get '/privacy', to: "static_pages#privacy"


end
