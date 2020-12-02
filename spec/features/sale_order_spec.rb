require 'rails_helper'

describe "sale_orders" do
  let(:user) {create(:user)}
  let(:sale_customer) {create(:sale_customer)}
  let!(:product) {create(:product_random)}
  let!(:product_random) {create_list(:product_random, 10)}
  let!(:repo) {create(:repo, user: user)}

  before do
    login_in(user)
  end
  describe "销售订单的CRUD" do

    scenario '创建一张不包含运费的销售订单', js: true do
      visit new_sale_order_path
      select product.specification, from: '型号规格'
      # fill_in '品名', with: product.name
      select repo.name, from: '存入仓库'
      fill_in '客户名称', with: '卡帝亚'
      fill_in '重量(千克)', with: '213'
      fill_in '数量', with: '100'
      fill_in '计量单位', with: '匹'
      fill_in '单价(元)', with: '9.5'
      fill_in '税率(例如:4.5%的减税就填0.045)', with: '0.045'
      fill_in '账单时间', with: 1.minute.ago
      fill_in '运费(元)', with: '150'
      check 'sale_orders[our_freight]'
      click_button '创建'
      expect(page).to have_content("创建成功")
      expect(page).to have_content(product.specification)
      sale_order = SaleOrder.last
      #   查看是否有一张付款单
      visit expenses_path
      if el = find("a", text: "跳过")
        el.click
      end
      expect(page).to have_content("销售单#{sale_order.order_id}")

      expense = Expense.last
      expect(page).to have_content("#{expense.order_id}")
      click_on expense.order_id
      paper_amount = find("th", text: "账面金额").find(:xpath, "./../td").text
      expect(paper_amount).to eq("150.0元")
    end

    scenario '创建一张我方付运费的销售订单', js: true do
      visit new_sale_order_path
      select product.specification, from: '型号规格'
      # fill_in '品名', with: product.name
      select repo.name, from: '存入仓库'
      fill_in '客户名称', with: '卡帝亚'
      fill_in '重量(千克)', with: '213'
      fill_in '数量', with: '100'
      fill_in '计量单位', with: '匹'
      fill_in '单价(元)', with: '9.5'
      fill_in '税率(例如:4.5%的减税就填0.045)', with: '0.045'
      fill_in '账单时间', with: 1.minute.ago
      fill_in '运费(元)', with: '150'
      check "是不是我方负责出运费?"
      click_button '创建'
      expect(page).to have_content("创建成功")
      order_id = SaleOrder.last.order_id
      expect(page).to have_content(product.specification)
      #   查看是否有一张付款单，应该有
      visit expenses_path
      if el = find("a", text: "跳过")
        el.click
      end
      expect(page).to have_content("销售单#{order_id}")
    end

    scenario '创建一张卖价里包含运费的销售订单', js: true do
      visit new_sale_order_path
      select product.specification, from: '型号规格'
      # fill_in '品名', with: product.name
      select repo.name, from: '存入仓库'
      fill_in '客户名称', with: '卡帝亚'
      fill_in '重量(千克)', with: '213'
      fill_in '数量', with: '100'
      fill_in '计量单位', with: '匹'
      fill_in '单价(元)', with: '9.5'
      fill_in '税率(例如:4.5%的减税就填0.045)', with: '0.045'
      fill_in '账单时间', with: 1.minute.ago
      fill_in '运费(元)', with: '150'
      click_button '创建'
      expect(page).to have_content("创建成功")
      sale_order = SaleOrder.last
      expect(page).to have_content(product.specification)
      #   查看是否有一张付款单,不用我方付运费，应该没有
      visit expenses_path
      if el = find("a", text: "跳过")
        el.click
      end
      expect(page).not_to have_content("销售单#{sale_order.order_id}")
    end

    scenario '编辑销售订单' do
      sale_order_1 = create(:sale_order, sale_customer: sale_customer, user: user, repo: repo, product: product)
      visit sale_orders_path
      el = find('a', text: sale_order_1.order_id)
      el.click
      click_link '编辑'
      select product.specification, from: '型号规格'
      # fill_in '品名', with: product.name
      select repo.name, from: '存入仓库'
      fill_in '客户名称', with: '卡帝亚'
      fill_in '重量(千克)', with: '2'
      fill_in '数量', with: '0'
      fill_in '计量单位', with: '件'
      fill_in '单价(元)', with: '19.5'
      fill_in '税率(例如:4.5%的减税就填0.045)', with: '0.055'
      fill_in '运费(元)', with: '150'
      check 'sale_orders[our_freight]'
      click_button '更新'
      expect(page).to have_content("成功")
      sale_order = SaleOrder.last
      expect(page).to have_content(product.specification)
      #   查看是否有一张付款单，应该有
      visit expenses_path
      expect(page).to have_content("销售单#{sale_order.order_id}")
    end

    scenario '审核多张销售订单' do
      sale_order_1 = create(:sale_order, sale_customer: sale_customer, user: user, repo: repo, product: product, freight: 500)
      sale_order_2 = create(:sale_order, sale_customer: sale_customer, user: user, repo: repo, product: product, freight: 200)
      visit sale_orders_path
      el = find('a', text: sale_order_1.order_id)
      text = el.find(:xpath, "./../../../div[2]/div[2]").text
      expect(text).to eq("未审核")
      el.click
      click_on "通过审核"
      # 返回主页，后面的未审核字样消失
      el = find('a', text: sale_order_1.order_id)
      text = el.find(:xpath, "./../../../div[2]/div[2]").text
      expect(text).to eq("")
      #   检查销售订单的金额是否加入客户数据中了
      sale_customer = sale_order_1.sale_customer

      visit sale_customer_path(sale_customer.id)
      sale_order_num = find("th", text: "已有订单数").find(:xpath, "./../td/a").text
      expect(sale_order_num).to eq("2")
      total_collection_required = find("th", text: "总计货款").find(:xpath, "./../td").text
      expect(total_collection_required).to eq((sale_order_1.total_price + sale_order_1.freight).to_s)
      uncollected = find("th", text: "未收款项").find(:xpath, "./../td").text
      expect(total_collection_required).to eq(uncollected)
      #   审核第二张订单
      visit sale_order_path(sale_order_2.id)
      click_on "通过审核"
      #   检查销售订单的金额是否加入客户数据中了
      visit sale_customer_path(sale_customer.id)

      total_collection_required = find("th", text: "总计货款").find(:xpath, "./../td").text
      expect(total_collection_required).to eq((sale_order_1.total_price + sale_order_1.freight + sale_order_2.total_price + sale_order_2.freight).to_s)
      uncollected = find("th", text: "未收款项").find(:xpath, "./../td").text
      expect(total_collection_required).to eq(uncollected)
    end

    scenario '作废订单并检查客户需要收回的货款' do
      sale_order_1 = create(:sale_order, sale_customer: sale_customer, user: user, repo: repo, product: product)
      sale_order_2 = create(:sale_order, sale_customer: sale_customer, user: user, repo: repo, product: product)
      visit sale_order_path(sale_order_1.id)
      click_on "通过审核"
      visit sale_order_path(sale_order_2.id)
      click_on "通过审核"

      sale_customer = sale_order_1.sale_customer
      #   检查销售订单的金额是否加入客户数据中了
      visit sale_customer_path(sale_customer.id)

      total_collection_required = find("th", text: "总计货款").find(:xpath, "./../td").text
      expect(total_collection_required).to eq((sale_order_1.total_price + sale_order_1.freight + sale_order_2.total_price + sale_order_2.freight).to_s)
      uncollected = find("th", text: "未收款项").find(:xpath, "./../td").text
      expect(total_collection_required).to eq(uncollected)

      visit sale_order_path(sale_order_1.id)
      click_on "作废"
      expect(page).to have_content('销售订单详情 已作废')

      # index页面上的类别里有这个作废订单
      visit sale_orders_path
      select "已作废订单", from: "type"
      click_on "搜索"
      expect(page).to have_content(sale_order_1.order_id)

      #   检查销售订单的金额是否加入客户数据中了
      visit sale_customer_path(sale_customer.id)
      total_collection_required = find("th", text: "总计货款").find(:xpath, "./../td").text
      expect(total_collection_required).to eq((sale_order_2.total_price + sale_order_2.freight).to_s)
      uncollected = find("th", text: "未收款项").find(:xpath, "./../td").text
      expect(total_collection_required).to eq(uncollected)
    end

    scenario "更新客户的清算金额后，重新计算货款" do
      sale_order_1 = create(:sale_order, sale_customer: sale_customer, user: user, repo: repo,
                            product: product, bill_time: 1.minute.ago)
      visit sale_order_path(sale_order_1.id)
      click_on "通过审核"
      sale_order_2 = create(:sale_order, sale_customer: sale_customer, user: user, repo: repo,
                            product: product, bill_time: 1.year.ago)
      visit sale_order_path(sale_order_2.id)
      click_on "通过审核"

      # 查看供应商
      sale_customer = sale_order_1.sale_customer
      visit sale_customer_path(sale_customer.id)
      # 检查订单数，需要付的货款
      sale_order_num = find("th", text: "已有订单数").find(:xpath, "./../td/a").text
      expect(sale_order_num).to eq("2")
      paid = find("th", text: "总计货款").find(:xpath, "./../td").text
      expect(paid).to eq((sale_order_1.total_price + sale_order_1.freight + sale_order_2.total_price + sale_order_2.freight).to_s)
      expect(page).not_to have_content('清算金额')
      #设置清算日期和金额
      click_on "编辑"
      fill_in "清算金额", with: 20000
      fill_in "清算时间", with: 10.days.ago
      click_on "更新"
      expect(page).to have_content('清算金额')
      # 检查订单数，需要付的货款
      sale_order_num = find("th", text: "已有订单数").find(:xpath, "./../td/a").text
      expect(sale_order_num).to eq("2")
      paid = find("th", text: "总计货款").find(:xpath, "./../td").text
      expect(paid.to_f).to eq(20000 + sale_order_1.total_price + sale_order_1.freight)
    end
  end

  describe "销售订单列表的查询" do
    let!(:sale_orders) {create_list(:sale_order, 10, user: user, sale_customer: sale_customer, product: product, repo: repo)}
    before do
      visit sale_orders_path
    end

    scenario "未作废订单-已作废订单" do
      select '未作废订单', from: 'type'
      click_button '搜索'
      sale_orders.each do |sale_order|
        expect(page).to have_content(sale_order.order_id)
        sale_order.order_declare_invalid(user)
      end

      select '未作废订单', from: 'type'
      click_button '搜索'
      sale_orders.each do |sale_order|
        expect(page).not_to have_content(sale_order.order_id)
      end
      expect(page).to have_content("空空如也")

      select '已作废订单', from: 'type'

      click_button '搜索'
      sale_orders.each do |sale_order|
        expect(page).to have_content(sale_order.order_id)
      end
    end

    scenario "未审核订单-已审核订单" do
      select '已审核订单', from: 'type'

      click_button '搜索'
      sale_orders.each do |sale_order|
        expect(page).not_to have_content(sale_order.order_id)
      end
      expect(page).to have_content("空空如也")

      select '未审核订单', from: 'type'

      click_button '搜索'
      sale_orders.each do |sale_order|
        expect(page).to have_content(sale_order.order_id)
        sale_order.pass_check_result(user)
      end

      select '已审核订单', from: 'type'

      click_button '搜索'
      sale_orders.each do |sale_order|
        expect(page).to have_content(sale_order.order_id)
      end
    end

    scenario "退货单" do
      select '退货单', from: 'type'
      click_button '搜索'
      sale_orders.each do |sale_order|
        expect(page).not_to have_content(sale_order.order_id)
      end
      expect(page).to have_content("空空如也")

      sale_orders.each do |sale_order|
        sale_order.is_return = true
        sale_order.save
      end

      select '退货单', from: 'type'

      click_button '搜索'
      sale_orders.each do |sale_order|
        expect(page).to have_content(sale_order.order_id)
      end

      select '退货单', from: 'type'

      click_button '搜索'
      sale_orders.each do |sale_order|
        expect(page).to have_content(sale_order.order_id)
      end
    end

    describe "特定名称" do
      scenario "产品名字" do
        fill_in 'search', with: sale_orders[0].product.name
        select '未作废订单', from: 'type'
        click_button '搜索'
        expect(page).to have_content(sale_orders[0].product.name)
      end
      scenario "产品型号" do
        fill_in 'search', with: sale_orders[0].product.specification
        select '未作废订单', from: 'type'
        click_button '搜索'
        expect(page).to have_content(sale_orders[0].product.specification)
      end
      scenario "客户名字" do
        fill_in 'search', with: sale_orders[0].sale_customer.name
        select '未作废订单', from: 'type'
        click_button '搜索'
        expect(page).to have_content(sale_orders[0].sale_customer.name)
      end
      scenario "订单号" do
        fill_in 'search', with: sale_orders[0].order_id
        select '未作废订单', from: 'type'
        click_button '搜索'
        expect(page).to have_content(sale_orders[0].order_id)
      end

    end

  end
end
