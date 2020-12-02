require 'rails_helper'


describe "intro" do
  let(:user) {create(:user)}
  before do
    login_in(user)
  end

  describe "首页引导" do
    scenario "暂时跳过，重启浏览器前不显示", js: true do
      visit '/'
      expect(page).to have_xpath('//div[@class="introjs-tooltipbuttons"]')
      find("a", text: "暂时跳过").click
      visit '/'
      expect(page).not_to have_xpath('//div[@class="introjs-tooltipbuttons"]')
    end
    scenario "点击下一步至完成", js: true do
      visit '/'
      expect(page).to have_xpath('//div[@class="introjs-tooltipbuttons"]')
      (1..7).each do |_|
        find("a", text: "下一步").click
      end
      find("a", text: "完成").click
      visit '/'
      visit users_path
      visit '/'
      expect(page).not_to have_xpath('//div[@class="introjs-tooltipbuttons"]')
    end
    scenario "下一步过程中退出", js: true do
      visit '/'
      expect(page).to have_xpath('//div[@class="introjs-tooltipbuttons"]')
      (1..3).each do |_|
        find("a", text: "下一步").click
      end
      find("a", text: "暂时跳过").click
      visit '/'
      visit users_path
      visit '/'
      expect(page).not_to have_xpath('//div[@class="introjs-tooltipbuttons"]')
    end
  end

  describe "特定内容的引导" do
    scenario "付款单", js: true do
      visit '/'
      expect(page).to have_xpath('//div[@class="introjs-tooltipbuttons"]')
      find("a", text: "暂时跳过").click
      find("a", text: /^新手引导/).click
      find("a", text: /^新的付款单/).click

      find("a", text: "填写新的付款单").click
      expect(page).to have_content('创建付款单')
      (1..9).each do |_|
        find("a", text: "下一步").click
      end
      expect(page).to have_content('可以拍照上传保留')
      find("a", text: "完成").click
      visit new_expense_path
      expect(page).not_to have_content('下一步')
    end
    scenario "收款单", js: true do
      visit '/'
      expect(page).to have_xpath('//div[@class="introjs-tooltipbuttons"]')
      find("a", text: "暂时跳过").click
      find("a", text: /^新手引导/).click
      find("a", text: /^新的收款单/).click

      find("a", text: "填写新的收款单").click
      expect(page).to have_content('创建收款信息')
      (1..7).each do |_|
        find("a", text: "下一步").click
      end
      expect(page).to have_content('可以拍照上传保留')
      find("a", text: "完成").click

      visit new_proceed_path
      expect(page).not_to have_content('下一步')
    end
    scenario "采购单", js: true do
      visit '/'
      expect(page).to have_xpath('//div[@class="introjs-tooltipbuttons"]')
      find("a", text: "暂时跳过").click
      find("a", text: /^新手引导/).click
      find("a", text: /^新的采购单/).click
      find("a", text: "填写新的采购单").click
      expect(page).to have_content('创建新的采购订单')
      (1..17).each do |_|
        find("a", text: "下一步").click
      end
      expect(page).to have_content('上传相关的单据留存')
      find("a", text: "完成").click

      visit new_purchase_order_path
      expect(page).not_to have_content('下一步')
    end
    scenario "销售单", js: true do
      products = create_list(:product_random, 10)
      visit '/'
      expect(page).to have_xpath('//div[@class="introjs-tooltipbuttons"]')
      find("a", text: "暂时跳过").click
      find("a", text: /^新手引导/).click
      find("a", text: /^新的销售单/).click
      find("a", text: "填写新的销售单").click
      expect(page).to have_content('创建销售订单')
      (1..14).each do |_|
        find("a", text: "下一步").click
      end
      expect(page).to have_content('上传相关的单据留存')
      find("a", text: "完成").click

      visit new_sale_order_path
      expect(page).not_to have_content('下一步')
    end
    scenario "新的改机信息", js: true do
      visit '/'
      expect(page).to have_xpath('//div[@class="introjs-tooltipbuttons"]')
      find("a", text: "暂时跳过").click
      find("a", text: /^新手引导/).click
      find("a", text: /^新的改机记录/).click
      find("a", text: "记录新的改机信息").click
      expect(page).to have_content('新的改机信息')
      (1..8).each do |_|
        find("a", text: "下一步").click
      end
      # expect(page).to have_content('')
      find("a", text: "完成").click

      visit new_change_machine_path
      expect(page).not_to have_content('下一步')
    end

    scenario "设置初始对账金额", js: true do
      purchase_suppliers = create_list(:purchase_supplier, 10)
      visit '/'
      expect(page).to have_xpath('//div[@class="introjs-tooltipbuttons"]')
      find("a", text: "暂时跳过").click
      find("a", text: /^新手引导/).click
      find("a", text: /^设置初始对账金额/).click
      find("a", text: "跳转到页面").click
      expect(page).to have_content('供应商管理界面')
      expect(page).to have_content('选择一个供应商进入')
      find("a", text: "完成").click

      find('a', text: purchase_suppliers[2].name).click
      expect(page).to have_content('点击进入编辑页面')
      find("a", text: "编辑").click
      expect(page).to have_content('编辑供应商信息')
      (1..3).each do |_|
        find("a", text: "下一步").click
      end
      find("a", text: "完成").click
    end

    scenario "导出对账单", js: true do
      sale_customers = create_list(:sale_customer, 10)
      visit '/'
      expect(page).to have_xpath('//div[@class="introjs-tooltipbuttons"]')
      find("a", text: "暂时跳过").click
      find("a", text: /^新手引导/).click
      find("a", text: /^导出对账单/).click
      find("a", text: "跳转到页面").click
      expect(page).to have_content('选择一个客户进入')
      find("a", text: "完成").click
      find("a", text: sale_customers[2].name).click
      expect(page).to have_content('客户信息详情')
      find("a", text: "完成").click
      expect(page).to have_content('导出对账单')
      visit new_change_machine_path
      expect(page).not_to have_content('下一步')
    end
  end
end