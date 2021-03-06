class ApiController < ApplicationController
  
  skip_before_action :require_authorized_network
  skip_before_action :verify_authenticity_token
  skip_before_action :login_required
  
  before_action do
    begin
      @payload = JSON.parse(request.body.read).with_indifferent_access
    rescue
      json({:error => 'Invalid json payload'}, 400)
      next
    end
    
    @auth_key = AuthKey.find_by_key(@payload[:auth_key])
    if @auth_key.nil?
      json({:error => 'Access denied'}, 403)
      next
    end
  end
  
  def notify
    notification = Notification.build_from_payload(@auth_key, @payload)
    if notification.save
      json(notification.to_hash, 201)
    else
      json({:errors => notification.errors}, 422)
    end
  end
  
  private
  
  def json(object, status = 200)
    render :json => object, :status => status
  end
  
end
