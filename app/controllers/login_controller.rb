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
  
  def api_request
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
      "10.233.1.1"=> 501,
      "10.233.2.1"=> 502,
      "10.233.3.1"=> 503,
      "10.233.4.1"=> 504,
      "10.233.5.1"=> 505,
      "10.233.6.1"=> 506,
      "10.233.7.1"=> 507,
      "10.233.8.1"=> 508,
      "10.233.9.1"=> 509,
      "10.233.10.1"=> 510,
      "10.233.11.1"=> 511,
      "10.233.12.1"=> 512,
      "10.233.13.1"=> 513,
      "10.233.21.1"=> 521,
      "10.233.23.1"=> 523,
      "10.233.25.1"=> 525,
      "10.233.30.1"=> 530
    }
    translations[user.switch]
  end
end
