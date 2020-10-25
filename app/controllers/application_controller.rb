class ApplicationController < ActionController::Base
  include SessionHelper

  def authenticate_user
    if !session[:user_id]
      flash[:warning] = "请先登录！"
      redirect_to new_session_path
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "#{exception.message}"
    redirect_to root_url
  end


end
