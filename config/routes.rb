Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'connect_four#index'
  get '/check', to: 'connect_four#check'
end
