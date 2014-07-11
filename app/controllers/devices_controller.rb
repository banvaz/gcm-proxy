class DevicesController < ApplicationController
  
  def show
    @device = Device.find(params[:id])
    @notifications = @device.notifications.asc.page(params[:page])
  end
  
end
