Rails.application.routes.draw do
  resources :stats, param: :username

  root to: 'stats#root'
end
