class ApplicationsController < ApplicationController
  
  before_action { params[:id] && @application = Application.find(params[:id].to_i) }
  
  def index
    @applications = Application.asc
  end
  
  def show
    @auth_keys = @application.auth_keys.asc
  end
  
  def new
    @application = Application.new
  end
  
  def create
    @application = Application.new(permitted_params)
    if @application.save
      redirect_to @application, :notice => "Application created successfully"
    else
      render :action => "new"
    end
  end
  
  def update
    if @application.update_attributes(permitted_params)
      redirect_to @application, :notice => "Application updated successfully"
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @application.destroy
    redirect_to :applications, :notice => "Application deleted successfully"
  end
  
  private
  
  def permitted_params
    params.require(:application).permit(:name, :api_key)
  end
  
end
