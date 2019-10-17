class LoginController < ApplicationController
  require 'net/http'
  require 'json'
  
  def show
    if session[:ip].present?
      redirect_to action: 'commit' and return
    end
  end
  
  def commit
    if session[:ip].blank?
      result = api_request(params) == '200'
      session[:ip] = request.remote_ip
    else
      code = true
    end
    
    if code
      @user = User.find_by(ip: session[:ip])
      @vlan = translate_ip_to_vlan(@user)
      BouncerJob.new(clientMAC: @user.mac, targetVLAN: @vlan).save!
      render "success"
    else
      message  = 'Username or password incorrect.'
      flash[:danger] = message
      render "show"
    end
  end
  
  def api_request(params)
    uri = URI.parse('https://geco.ethz.ch/api/v2/auth')
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    api_request = Net::HTTP::Post.new(uri.request_uri)
    api_request.set_form_data({'username': params[:username], 'password': params[:password]})
    api_request['Content-Type'] = 'application/x-www-form-urlencoded'
    api_request['X-API-KEY'] = Rails.configuration.api_key
    
    return http.request(api_request).code
  end
  
  def translate_ip_to_vlan(user)
    translations = {
      "10.233.254"=> 501,
      "10.233.254.2"=> 502,
      "10.233.254.3"=> 503,
      "10.233.254.4"=> 504,
      "10.233.254.5"=> 505,
      "10.233.254.6"=> 506,
      "10.233.254.7"=> 507,
      "10.233.254.8"=> 508,
      "10.233.254.9"=> 509,
      "10.233.254.10"=> 510,
      "10.233.254.11"=> 511,
      "10.233.254.12"=> 512,
      "10.233.254.13"=> 513,
      "10.233.254.21"=> 521,
      "10.233.254.23"=> 523,
      "10.233.254.25"=> 525,
      "10.233.254.30"=> 530
    }
    translations[user.switch]
  end
end
