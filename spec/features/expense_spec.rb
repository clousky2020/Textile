require 'rails_helper'


describe 'expense' do
  let(:user) {create(:user)}
  let(:purchase_supplier) {create(:purchase_supplier)}
  before do
    login_in(user)
  end
  describe "付款单的CRUD" do
    scenario '创建一张新的付款单' do
      visit '/'
      click_link '填写新的付款单'
      fill_in '交易方', with: purchase_supplier.name
      fill_in '类型', with: '货款'
      fill_in '账面金额', with: '210.0'
      fill_in '实际金额', with: '210.0'
      select '银行', from: '账户所属'
      fill_in '经手人ID', with: '1'
      click_button '创建'
      expect(page).to have_content("创建成功")
    end

    scenario '审核付款单并检查付款金额是否记入供应商' do
      expense = create(:expense, user: user, counterparty: purchase_supplier.name)
      visit expenses_path
      el = find('a', text: expense.order_id)
      text = el.find(:xpath, "./../../../div[2]/div[2]").text
      expect(text).to eq("未审核")
      el.click
      click_on "通过审核"
      # 返回主页，后面的未审核字样消失
      el = find('a', text: expense.order_id)
      text = el.find(:xpath, "./../../../div[2]/div[2]").text
      expect(text).to eq("")
      #   检查供应商界面是否有这笔付款单的内容
      visit purchase_supplier_path(purchase_supplier.id)
      # 检查各项数值
      expense_num = find("th", text: "已有付款单数").find(:xpath, "./../td/a").text
      expect(expense_num).to eq("1")
      paid = find("th", text: "已付").find(:xpath, "./../td").text
      expect(paid).to eq(expense.paper_amount.to_s)
    end

    scenario '删除未审核的付款单' do
      expense = create(:expense, user: user, counterparty: purchase_supplier.name)
      visit expenses_path
      el = find('a', text: expense.order_id)
      text = el.find(:xpath, "./../../../div[2]/div[2]").text
      expect(text).to eq("未审核")
      delete_link = el.find(:xpath, "./../../../div[3]/div[2]/a")
      expect(delete_link.text).to eq("删除")
      delete_link.click
      expect(page).to have_content("付款单#{expense.order_id}已删除")
      visit expenses_path
      expect(page).not_to have_content(expense.order_id)
    end

    scenario '作废付款单并检查付款金额是否从供应商处扣除了' do
      expense = create(:expense, user: user, counterparty: purchase_supplier.name)
      visit expense_path(expense.id)
      click_on "通过审核"

      # 查看供应商
      visit purchase_supplier_path(purchase_supplier.id)
      # 检查各项数值
      expense_num = find("th", text: "已有付款单数").find(:xpath, "./../td/a").text
      expect(expense_num).to eq("1")
      paid = find("th", text: "已付").find(:xpath, "./../td").text
      expect(paid).to eq(expense.paper_amount.to_s)
      visit expenses_path
      el = find('a', text: expense.order_id)
      el.click
      click_on "作废"
      expect(page).to have_content('付款单详情 已作废')
      # index页面上的类别里有这个作废订单
      visit expenses_path
      select "已作废订单", from: "type"
      click_on "搜索"
      expect(page).to have_content(expense.order_id)
      # 查看供应商
      visit purchase_supplier_path(purchase_supplier.id)
      # 检查各项数值
      expense_num = find("th", text: "已有付款单数").find(:xpath, "./../td/a").text
      expect(expense_num).to eq("0")
      paid = find("th", text: "已付").find(:xpath, "./../td").text
      expect(paid).to eq('0.0')
    end
  end

  describe "付款列表的查询" do
    let!(:expenses) {create_list(:expense, 10, user: user)}
    before do
      visit expenses_path
    end

    scenario "未作废订单-已作废订单" do
      select '未作废订单', from: 'type'
      select '账单时间降序', from: 'order'
      click_button '搜索'
      expenses.each do |expense|
        expect(page).to have_content(expense.order_id)
        expense.order_declare_invalid(user)
      end

      select '未作废订单', from: 'type'
      select '账单时间升序', from: 'order'
      click_button '搜索'
      expenses.each do |expense|
        expect(page).not_to have_content(expense.order_id)
      end
      expect(page).to have_content("空空如也")

      select '已作废订单', from: 'type'
      select '订单号', from: 'order'
      click_button '搜索'
      expenses.each do |expense|
        expect(page).to have_content(expense.order_id)
      end
    end

    scenario "未审核订单-已审核订单" do
      select '已审核订单', from: 'type'
      select '账单时间升序', from: 'order'
      click_button '搜索'
      expenses.each do |expense|
        expect(page).not_to have_content(expense.order_id)
      end
      expect(page).to have_content("空空如也")

      select '未审核订单', from: 'type'
      select '账单时间降序', from: 'order'
      click_button '搜索'
      expenses.each do |expense|
        expect(page).to have_content(expense.order_id)
        expense.pass_check_result(user)
      end

      select '已审核订单', from: 'type'
      select '订单号', from: 'order'
      click_button '搜索'
      expenses.each do |expense|
        expect(page).to have_content(expense.order_id)
      end
    end

    scenario "未报销订单" do
      select '未报销订单', from: 'type'
      select '账单时间升序', from: 'order'
      click_button '搜索'
      expenses.each do |expense|
        expect(page).not_to have_content(expense.order_id)
      end
      expect(page).to have_content("空空如也")

      expenses.each do |expense|
        expense.need_reimburse = true
        expense.save
      end

      select '未报销订单', from: 'type'
      select '账单时间降序', from: 'order'
      click_button '搜索'
      expenses.each do |expense|
        expect(page).to have_content(expense.order_id)
      end

      select '未报销订单', from: 'type'
      select '订单号', from: 'order'
      click_button '搜索'
      expenses.each do |expense|
        expect(page).to have_content(expense.order_id)
      end
    end

    describe "特定名称" do
      scenario "交易方名字" do
        fill_in 'search', with: expenses[0].counterparty
        select '未作废订单', from: 'type'
        click_button '搜索'
        expect(page).to have_content(expenses[0].counterparty)
      end
      scenario "备注" do
        fill_in 'search', with: expenses[0].remark
        select '未作废订单', from: 'type'
        click_button '搜索'
        expect(page).to have_content(expenses[0].remark)
      end
      scenario "订单号" do
        fill_in 'search', with: expenses[0].order_id
        select '未作废订单', from: 'type'
        click_button '搜索'
        expect(page).to have_content(expenses[0].order_id)
      end
    end
  end
end
