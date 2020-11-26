class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]

  def edit
  end


  def update
    if !@user.authenticate(params[:user][:password])
      flash[:danger] = "原密码错误"
      render 'password_resets/edit'
    elsif params[:user][:password_new] != params[:user][:password_confirmation]
      flash[:danger] = "两次输入的密码不一样"
      render 'password_resets/edit'
    else
      @user.password = params[:user][:password_confirmation]
      if @user.save
        flash[:success] = "密码已经更改"
        redirect_to root_url
      else
        flash[:danger] = "#{@user.errors.full_messages.join(',')}"
        render 'password_resets/edit'
      end
    end
  end



  private

  def get_user
    @user = User.find(params[:id])
  end


end
