class LoginController < ApplicationController
  require 'net/http'
  require 'json'
  
  def show
  end
  
  def commit
    if api_request(params) == '200'
      @user = User.find_by(ip: request.remote_ip)
      if @user.nil?
        message  = 'Host not found in RADIUS database.'
        flash[:danger] = message
        render "show"
        return
      end
      @vlan = translate_ip_to_vlan(@user)
      if @vlan.nil?
        message  = 'VLAN for Switch not found.'
        flash[:danger] = message
        render "show"
        return
      end
      BouncerJob.new(clientMAC: @user.mac, targetVLAN: @vlan).save!
      LoginLog.new(mac: @user.mac, username: params[:username]).save!
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
      "10.233.253.1" => 501,
      "10.233.253.2" => 502,
      "10.233.253.3" => 503,
      "10.233.253.4" => 504,
      "10.233.253.5" => 505,
      "10.233.253.6" => 506,
      "10.233.253.7" => 507,
      "10.233.253.8" => 508,
      "10.233.253.9" => 509,
      "10.233.253.10" => 510,
      "10.233.253.11" => 511,
      "10.233.253.12" => 512,
      "10.233.253.13" => 513,
      "10.233.253.14" => 514,
      "10.233.253.15" => 515,
      "10.233.253.16" => 516,
      "10.233.253.17" => 517,
      "10.233.253.18" => 518,
      "10.233.253.19" => 519,
      "10.233.253.20" => 520,
      "10.233.253.21" => 521,
      "10.233.253.22" => 522,
      "10.233.253.23" => 523,
      "10.233.253.24" => 524,
      "10.233.253.25" => 525,
      "10.233.253.26" => 526,
      "10.233.253.27" => 527,
      "10.233.253.28" => 528,
      "10.233.253.29" => 529,
      "10.233.253.30" => 530,
      "10.233.253.31" => 531,
      "10.233.253.32" => 532,
    }
    translations[user.switch]
  end
end
