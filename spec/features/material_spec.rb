require 'rails_helper'

describe "material" do
  let(:user) {create(:user)}
  let(:repo) {create(:repo, user: user)}
  let(:purchase_supplier) {create(:purchase_supplier)}
  let!(:material) {create(:material, purchase_supplier: purchase_supplier)}
  before(:each) do
    login_in(user)
  end

  describe "原料crud" do
    it "新的原料" do
      visit '/'
      click_link '生产资料'
      click_link "原料管理"
      click_link "新建"
      fill_in '品名', with: "测试用品名"
      fill_in '型号规格', with: "测试用型号"
      fill_in '公司名', with: purchase_supplier.name
      fill_in '描述', with: "测试描述"
      fill_in '备注', with: "测试备注"
      select '包', from: "计量单位"
      click_button "创建"

      expect(page).to have_content("创建成功")
      visit materials_path
      expect(page).to have_content(material.name)
    end

    it '编辑原料' do
      purchase_supplier_2 = create(:purchase_supplier, name: "测试")
      visit '/'
      click_link "生产资料"
      click_link "原料管理"
      click_link material.name
      click_on "编辑"
      fill_in '品名', with: "测试用品名2"
      fill_in '型号规格', with: "测试用型号2"
      fill_in '公司名', with: purchase_supplier_2.name
      click_button "更新"
      expect(page).to have_content("测试用品名2")
      expect(page).to have_content("测试用型号2")
      expect(page).to have_content(purchase_supplier_2.name)
    end

    it '有订单的情况下，可以查看历史订单' do
      purchase_order_1 = create(:purchase_order, purchase_supplier: purchase_supplier, material: material, user: user, repo: repo, price: 10)
      purchase_order_1.pass_check_result(user)
      purchase_order_2 = create(:purchase_order, purchase_supplier: purchase_supplier, material: material, user: user, repo: repo, price: 15)
      purchase_order_2.pass_check_result(user)
      visit '/'
      click_link "生产资料"
      click_link "原料管理"
      click_link material.name
      # 有不同价格的情况下会有历史价格曲线
      expect(page).to have_content("历史价格曲线")
      # 有订单的情况下，会把历史订单和价格显示出来
      expect(page).to have_content("历史订单列表")
      expect(page).to have_content(purchase_order_1.order_id)
      expect(page).to have_content(purchase_order_2.order_id)
    end

    it '更改订单的原料后，原料界面这里也更改' do
      purchase_order_1 = create(:purchase_order, purchase_supplier: purchase_supplier, material: material, user: user, repo: repo, price: 10)
      visit '/'
      click_link "订单管理"
      click_link "采购单"
      click_link purchase_order_1.order_id
      click_on "编辑"
      fill_in '品名', with: "更改后的品名"
      fill_in '型号规格', with: "更改后的型号"
      click_on "更新"
      expect(page).to have_content("成功")
      visit materials_path
      expect(page).to have_content("更改后的品名")
      click_link "更改后的品名"
      expect(page).to have_content("更改后的型号")
    end

  end


end
