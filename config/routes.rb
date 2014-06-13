Rails.application.routes.draw do
  
  resources :services
  resources :identifies

  root 'services#new'


end
