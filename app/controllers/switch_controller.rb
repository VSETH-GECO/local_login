class SwitchController < ApplicationController
  def show
    
  end

  def commit
    @user = User.find_by(ip: request.remote_ip)
    @vlan = params[:vlan]
    BouncerJob.new(clientMAC: @user.mac, targetVLAN: params[:vlan]).save!
  end
end
