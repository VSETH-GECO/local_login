Rails.application.routes.draw do

  root 'login#show'
  get '/login', to: 'login#show'
  get '/success', to: 'login#commit'
  post '/success', to: 'login#commit'
  get '/switch', to: 'switch#show'
  post '/switch', to: 'switch#commit'
end
