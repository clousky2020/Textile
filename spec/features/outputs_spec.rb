require 'rails_helper'

describe "outputs" do
  let(:user) {create(:user)}
  let!(:employee) {create_list :employees, 10}
  let!(:machine) {create_list :machine, 10}
  let!(:product) {create_list :product_random, 10}

  before do
    login_in(user)
  end

  describe "产量记录" do
    scenario "新建", js: true do
      visit root_path
      find("a", text: "暂时跳过").click
      click_link "生产资料"
      click_link "产量记录"
      click_link "添加新的产量记录"
      expect(page).to have_content("增加产量记录")
      select 2, from: "work_id"
      fill_in "machine_id", with: machine[0].id
      fill_in "weight", with: 30
      click_on "添加"
      select 1, from: "work_id"
      fill_in "machine_id", with: machine[1].id
      fill_in "weight", with: 40
      click_on "添加"
      expect(page).to have_css('div.record')
      click_on "提交"
      expect(page).to have_content('成功创建')
      expect(page).to have_content('产量记录')
    end

  end


end
