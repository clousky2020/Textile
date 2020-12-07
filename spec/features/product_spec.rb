require 'rails_helper'

describe "product" do
  let(:user) {create(:user)}
  let(:repo) {create(:repo, user: user)}
  let(:sale_customer) {create(:sale_customer)}
  let!(:product) {create(:product)}
  before(:each) do
    login_in(user)
  end

  describe "产品crud" do
    it "新的产品" do
      visit '/'
      click_link '生产资料'
      click_link "产品管理"
      click_link "新建"
      fill_in '品名', with: "测试用品名"
      fill_in '型号规格', with: "测试用型号"
      fill_in "计量单位", with: '匹'
      click_button "创建"
      expect(page).to have_content("创建成功")
      visit products_path
      expect(page).to have_content(product.name)
    end

    it '编辑产品' do
      sale_customer_2 = create(:sale_customer, name: "测试")
      visit '/'
      click_link "生产资料"
      click_link "产品管理"
      click_link product.name
      click_on "编辑"
      fill_in '品名', with: "测试用品名2"
      fill_in '型号规格', with: "测试用型号2"
      click_button "更新"
      expect(page).to have_content("测试用品名2")
      expect(page).to have_content("测试用型号2")
      expect(page).to have_content(sale_customer_2.name)
    end

    it '有订单的情况下，可以在产品详情页面查看历史订单' do
      sale_order_1 = create(:sale_order, sale_customer: sale_customer, product: product, user: user, repo: repo, price: 10)
      sale_order_1.pass_check_result(user)
      sale_order_2 = create(:sale_order, sale_customer: sale_customer, product: product, user: user, repo: repo, price: 15)
      sale_order_2.pass_check_result(user)
      visit '/'
      click_link "生产资料"
      click_link "产品管理"
      click_link product.name
      # 有不同价格的情况下会有历史价格曲线
      expect(page).to have_content("历史价格曲线")
      # 有订单的情况下，会把历史订单和价格显示出来
      expect(page).to have_content("历史订单列表")
      expect(page).to have_content(sale_order_1.order_id)
      expect(page).to have_content(sale_order_2.order_id)
    end

    it '删除产品' do
      products = create_list(:product_random, 9)
      visit products_path
      products.each do |product|
        expect(page).to have_content(product.name)
        expect(page).to have_content(product.specification)
      end
      product = products[0]
      el = find("td") {|el| el.text == product.specification}
      delete_link = el.find(:xpath, "./../td[5]/a")
      delete_link.click
      expect(page).not_to have_content(product.name)
      expect(page).not_to have_content(product.specification)
    end

  end


end
