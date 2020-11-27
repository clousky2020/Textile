require 'rails_helper'

describe "dashboard" do
  let!(:user) {create(:user)}
  let!(:repo) {create(:repo, user: user)}
  let!(:purchase_supplier) {create(:purchase_supplier)}
  let!(:sale_customer) {create(:sale_customer)}
  let!(:material) {create(:material, purchase_supplier: purchase_supplier)}
  let!(:product) {create(:product)}

  let!(:purchase_orders) {create_list(:purchase_order, 40, purchase_supplier: purchase_supplier,
                                      material: material, user: user, repo: repo)}
  let!(:sale_orders) {create_list(:sale_order, 40, user: user, repo: repo, sale_customer: sale_customer,
                                  product: product)}
  let!(:expenses) {create_list(:expense, 10, user: user, counterparty: purchase_supplier.name)}
  let!(:proceeds) {create_list(:proceed, 10, user: user, sale_customer: SaleCustomer.find(rand(1..SaleCustomer.count)))}

  before do
    login_in(user)
  end

  scenario '页面点击能查看图表', js: true do

    purchase_orders.each do |purchase_order|
      purchase_order.pass_check_result(user)
    end
    sale_orders.each do |sale_order|
      sale_order.pass_check_result(user)
    end
    expenses.each do |expense|
      expense.pass_check_result(user)
    end
    proceeds.each do |proceed|
      proceed.pass_check_result(user)
    end

    visit root_path
    el = find("a", text: "暂时跳过")
    el.click
    expect(page).to have_content("角色栏")
    expect(page).to have_content("待处理清单")
    expect(page).to have_content("常用功能")
    expect(page).to have_content("最近7天的情况")
    expect(page).to have_content("新手引导")
    expect(page).to have_content("图表查询")

    fill_in "start_date", with: 1.minute.ago

    click_button "订单收支"
    expect(page).to have_content("好像没有找到符合要求的数据")
    click_button "支出类别"
    expect(page).to have_content("好像没有找到符合要求的数据")
    click_button "最高交易金额的公司"
    expect(page).to have_content("好像没有找到符合要求的订单")

    fill_in "start_date", with: 180.days.ago

    click_button "订单收支"
    find(:xpath, '//canvas[@id="check_sale_proceed_chart"]')
    find(:xpath, '//canvas[@id="check_purchase_expense_chart"]')
    find(:xpath, '//canvas[@id="check_proceed_expense_chart"]')
    click_button "支出类别"
    find(:xpath, '//canvas[@id="check_expense_ratio_chart"]')
    click_button "最高交易金额的公司"
    find(:xpath, '//canvas[@id="check_purchase_supplier_top_chart"]')
    find(:xpath, '//canvas[@id="check_sale_orders_top_chart"]')
  end


end
