Rails.application.routes.draw do
  
  resources :questions

  resources :posts

  get 'about' => 'welcome#about'
  
  #get 'welcome/contact'

  root 'welcome#index'
end
