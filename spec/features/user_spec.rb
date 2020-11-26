require 'rails_helper'

describe "users" do
  let(:user) {create(:user)}
  before do
    login_in(user)
  end

  it "更改账户密码" do
    visit '/'
    click_link user.name
    click_link "更改密码"
    fill_in "user[password]", with: user.password
    fill_in "user[password_new]", with: "000000"
    fill_in "user[password_confirmation]", with: "000000"
    click_button "更新"
    visit '/'
    click_link user.name
    click_link "退出"
    fill_in 'sessions_name', with: user.name
    fill_in 'sessions_password', with: "000000"
    click_button '登录'
    expect(page).to have_content("成功登录")
  end

  it '查看自己的个人信息' do
    visit '/'
    click_on user.name
    click_on "个人信息"
    expect(page).to have_content("用户档案")
    expect(page).to have_content("报销单情况")
  end

end
