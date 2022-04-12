class SwitchController < ApplicationController
  def show
    
  end

  def commit
    @user = User.find_by(ip: request.remote_ip)
    @vlan = params[:vlan]

    if @user.nil?
      message  = 'Host not found in RADIUS database.'
      flash[:danger] = message
      render "show"
      return
    end

    if @vlan.nil?
      message  = 'VLAN not specified.'
      flash[:danger] = message
      render "show"
    end

    if @vlan < 490 || @vlan > 495
      message  = 'VLAN invalid'
      flash[:danger] = message
      render "show"
    end

    BouncerJob.new(clientMAC: @user.mac, targetVLAN: params[:vlan]).save!
  end
end
