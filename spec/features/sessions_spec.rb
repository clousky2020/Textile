require 'rails_helper'

describe "sessions" do
  let(:user) {create(:user)}
  before {visit '/sessions/new'}
  it {expect(page).to have_content('登录界面')}

  it "正确的账户密码才能登录账户" do
    fill_in 'sessions_name', with: user.name
    fill_in 'sessions_password', with: user.password
    click_button '登录'
    expect(page).to have_content('成功')
  end

  it "错误的账号密码不能登录账户" do
    fill_in 'sessions_name', with: user.name
    fill_in 'sessions_password', with: "#{user.password}+1"
    click_button '登录'
    expect(page).to have_content('错误')
  end

  it "被锁住的账户不能登录" do
    user = create(:lock_user)
    fill_in 'sessions_name', with: user.name
    fill_in 'sessions_password', with: user.password
    click_button '登录'
    expect(page).to have_content('账户已锁定')
  end

  it "点击退出" do
    fill_in 'sessions_name', with: user.name
    fill_in 'sessions_password', with: user.password
    click_button '登录'
    click_link user.name
    click_link '退出'
  end

end
