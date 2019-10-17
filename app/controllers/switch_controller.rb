class SwitchController < ApplicationController
  def show
    
  end

  def commit
    @user = User.find_by(ip: request.remote_ip)
    BouncerJob.new(clientMAC: @user.mac, targetVLAN: params[:vlan]).save!
  end
end
