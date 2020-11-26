class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def new

  end

  def create
    user = User.find_by(name: params[:sessions][:name])
    if user && user.is_lock == true
      flash[:warning] = "账户已锁定，请联系管理员"
      render 'sessions/new'
    elsif user && user.authenticate(params[:sessions][:password])
      login_in user
      flash[:success] = "成功登录"
      if session[:forwarding_url]
        redirect_to session[:forwarding_url]
      else
        redirect_to root_url
      end
    else
      flash[:warning] = "错误的邮箱/密码"
      render 'sessions/new'
    end
  end

  def destroy
    logout
    redirect_to new_session_path
  end
end
