Rails.application.routes.draw do

  root 'login#show'
  get '/login', to: 'login#show'
  post '/login', to: 'login#commit'
  get '/switch', to: 'switch#show'
  post '/switch', to: 'switch#commit'
end
