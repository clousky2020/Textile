class ApplicationController < ActionController::Base
  include SessionHelper
  before_action :authenticate_user

  def authenticate_user
    if !session[:user_id]
      flash[:warning] = "请先登录！"
      store_location
      redirect_to new_session_path
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = "没有权限执行此操作"
    redirect_to root_url
  end


end
