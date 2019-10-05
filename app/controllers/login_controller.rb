class LoginController < ApplicationController
  require 'net/http'
  require 'json'
  
  def show
    
  end
  
  def commit
    uri = URI.parse('https://geco.ethz.ch/api/v2/auth')
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({'email': params[:username], 'password': params[:password]})
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request['X-API-KEY'] = Rails.configuration.api_key
    
    response = http.request(request)
    
    if response.code == '200'
      render "success"
    else
      message  = 'Username or password incorrect.'
      flash[:danger] = message
      render "show"
    end
  end
end
