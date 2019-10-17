class SwitchController < ApplicationController
  def show
    
  end

  def commit
    @user = User.find_by(ip: session[:ip])
    BouncerJob.new(clientMAC: @user.mac, targetVLAN: params[:vlan]).save!
  end
end
