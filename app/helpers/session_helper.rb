module SessionHelper
  def login_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
  end

  #重定向到登录前的地址
  def redirect_back_for(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # 保存登录前的地址
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  # 保存登录前的地址
  def store_referrer_location
    cookies[:forwarding_url] = request.referrer
  end
  #重定向到登录前的地址
  def redirect_back_referrer_for(default)
    redirect_to(cookies[:forwarding_url] || default)
    cookies.delete(:forwarding_url)
  end
end
