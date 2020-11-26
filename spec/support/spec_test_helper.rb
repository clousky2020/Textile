module SpecTestHelper
  def login(user)
    request.session[:user_id] = user.id
  end

  def current_user
    User.find(request.session[:user_id])
  end

  def login_in(user)
    visit 'sessions/new'
    fill_in 'sessions_name', with: user.name
    fill_in 'sessions_password', with: user.password
    click_button '登录'
  end
end
