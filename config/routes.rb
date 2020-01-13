# frozen_string_literal: true

Rails.application.routes.draw do
  resources :stats, param: :username

  get 'api/usernames', to: 'api#usernames'
  get 'api/stats/:username', to: 'api#stats', as: 'api_stats'

  root to: 'stats#root'
end
