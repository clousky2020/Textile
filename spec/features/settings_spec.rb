require 'rails_helper'

describe "setting" do
  let(:user) {create(:user)}
  let!(:setting_1) {create(:setting)}
  let!(:setting_2) {create(:setting)}
  let!(:setting_3) {create(:setting)}
  before do
    login_in(user)
  end

  it '进入设置页面' do
    visit '/'
    click_on "参数设定"
    expect(page).to have_content(setting_1.description)
    expect(page).to have_content(setting_2.description)
    expect(page).to have_content(setting_3.description)
  end

  it '点击一个设定，状态变更', js: true do
    visit '/settings'
    el = find("textarea", text: setting_1.description)
    el_text = el.find(:xpath, "./../label").text
    expect(el_text).to eq("状态：关闭")
    el_click = el.find(:xpath, "./../input[4]")
    el_click.click
    el = find("textarea", text: setting_1.description)
    el_text = el.find(:xpath, "./../label").text
    expect(el_text).to eq("状态：开启")
    el_click = el.find(:xpath, "./../input[4]")
    el_click.click
    el = find("textarea", text: setting_1.description)
    el_text = el.find(:xpath, "./../label").text
    expect(el_text).to eq("状态：关闭")
  end

end
