class SessionController < ApplicationController

  def new

  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      login_in user
      flash[:success] = "成功登录"
      redirect_to root_url
    else
      flash[:warning] = "错误的邮箱/密码"
      render :'session/new'
    end
  end

  def destroy
    logout
    redirect_to new_session_path
  end
end
