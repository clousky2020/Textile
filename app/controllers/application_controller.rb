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
    store_referrer_location
    flash[:warning] = "没有权限执行此操作"
    redirect_back_referrer_for root_url
  end

end
