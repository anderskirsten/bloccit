Rails.application.routes.draw do

  resources :topics do
    resources :posts, except: [:index]
    resources :sponsored_posts, except: [:index]
  end
  
  resources :questions

  get 'about' => 'welcome#about'
  
  #get 'welcome/contact'

  root 'welcome#index'
end
