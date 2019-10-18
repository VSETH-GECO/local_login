class LoginController < ApplicationController
  require 'net/http'
  require 'json'
  
  def show
  end
  
  def commit
    if api_request(params) == '200'
      @user = User.find_by(ip: request.remote_ip)
      if @user.nil?
        message  = 'User not found.'
        flash[:danger] = message
        render "show"
        return
      end
      @vlan = translate_ip_to_vlan(@user)
      if @vlan.nil?
        message  = 'VLAN not found.'
        flash[:danger] = message
        render "show"
        return
      end
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
    
    response = http.request(api_request)
    puts response
    return response.code
  end
  
  def translate_ip_to_vlan(user)
    translations = {
      "10.233.200.130" => 530,
      "10.233.30.1" => 530,
      "10.233.254.30" => 530,
      "10.233.252.30" => 530,
      "10.233.10.1" => 510,
      "10.233.254.10" => 510,
      "10.233.252.10" => 510,
      "10.233.200.108" => 508,
      "10.233.8.1" => 508,
      "10.233.254.8" => 508,
      "10.233.252.8" => 508,
      "10.233.7.1" => 507,
      "10.233.254.7" => 507,
      "10.233.252.7" => 507,
      "10.233.200.106" => 506,
      "10.233.6.1" => 506,
      "10.233.254.6" => 506,
      "10.233.252.6" => 506,
      "10.233.200.125" => 525,
      "10.233.25.1" => 525,
      "10.233.254.25" => 525,
      "10.233.252.25" => 525,
      "10.233.200.103" => 503,
      "10.233.3.1" => 503,
      "10.233.254.3" => 503,
      "10.233.252.3" => 503,
      "10.233.200.105" => 505,
      "10.233.5.1" => 505,
      "10.233.254.5" => 505,
      "10.233.252.5" => 505
    }
    translations[user.switch]
  end
end
