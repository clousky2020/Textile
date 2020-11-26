require 'rails_helper'

describe "purchase_orders" do
  let!(:user) {create(:user)}
  let(:purchase_supplier) {create(:purchase_supplier)}
  let(:material) {create(:material, purchase_supplier: purchase_supplier)}
  let!(:repo) {create(:repo, user: user)}

  before do
    login_in(user)
  end

  scenario '创建一张包含运费的采购订单' do
    visit '/'
    click_link "填写新的采购单"
    fill_in '品名', with: '测试用品名'
    fill_in '型号规格', with: '测试用规格型号'
    fill_in '批号', with: "测试用批号"
    select repo.name, from: '存入仓库'
    fill_in '供应商', with: purchase_supplier.name
    fill_in '重量(千克)', with: 500
    fill_in '数量', with: rand(1000)
    select '包', from: '计量单位'
    fill_in '单价(元/千克)', with: 10
    fill_in '税率(例如:4.5%的减税就填0.045)', with: 0
    fill_in '运费(元)', with: 200
    fill_in '账单时间', with: 10.minutes.ago
    click_button '创建'
    expect(page).to have_content("创建成功")
    expect(page).to have_content('测试用规格型号')
    click_on '测试用规格型号'
    expect(page).to have_content("原材料详情")
    #   查看原料管理里是否有这种原料
    visit materials_path
    expect(page).to have_content("测试用品名")
    #   查看是否有一张付款单
    visit expenses_path
    expense = Expense.last
    expect(expense).to eq(nil)
  end

  scenario '创建我方付运费的采购订单' do
    visit '/'
    click_link "填写新的采购单"
    fill_in '品名', with: material.name
    fill_in '型号规格', with: material.specification
    fill_in '批号', with: "测试用批号"
    select repo.name, from: '存入仓库'
    fill_in '供应商', with: purchase_supplier.name
    fill_in '重量(千克)', with: rand(1000)
    fill_in '数量', with: rand(1000)
    select '包', from: '计量单位'
    fill_in '单价(元/千克)', with: rand(100)
    fill_in '税率(例如:4.5%的减税就填0.045)', with: rand / 10
    fill_in '运费(元)', with: 200
    fill_in '账单时间', with: 10.minutes.ago
    check 'purchase_orders[our_freight]'
    click_button '创建'
    expect(page).to have_content("创建成功")
    expect(page).to have_content(material.specification)
    #   查看是否有一张付款单
    visit expenses_path
    expense = Expense.last
    expect(page).to have_content("#{expense.order_id}")
    el = find('a', text: expense.order_id)
    el.click
    paper_amount = find("th", text: "账面金额").find(:xpath, "./../td").text
    expect(paper_amount).to eq("200.0元")
  end
  scenario '创建我方付运费的退货订单' do
    visit '/'
    click_link "填写新的采购单"
    fill_in '品名', with: material.name
    fill_in '型号规格', with: material.specification
    fill_in '批号', with: "退货用批号"
    select repo.name, from: '存入仓库'
    fill_in '供应商', with: purchase_supplier.name
    fill_in '重量(千克)', with: rand(1000)
    fill_in '数量', with: rand(1000)
    select '包', from: '计量单位'
    fill_in '单价(元/千克)', with: rand(100)
    fill_in '税率(例如:4.5%的减税就填0.045)', with: rand / 10
    fill_in '运费(元)', with: 200
    fill_in '账单时间', with: 10.minutes.ago
    check 'purchase_orders[our_freight]'
    check "是退货/退押金吗？"
    click_button '创建'
    expect(page).to have_content("创建成功")
    expect(page).to have_content(material.specification)
    #   查看是否有一张付款单
    visit expenses_path
    expense = Expense.last
    expect(page).to have_content("#{expense.order_id}")
    el = find('a', text: expense.order_id)
    el.click
    paper_amount = find("th", text: "账面金额").find(:xpath, "./../td").text
    expect(paper_amount).to eq("200.0元")
  end
  scenario '编辑采购订单' do
    purchase_order_1 = create(:purchase_order, purchase_supplier: purchase_supplier, user: user, repo: repo,
                              material: material, freight: 50)
    visit purchase_orders_path
    click_link purchase_order_1.order_id
    click_on '编辑'
    fill_in '品名', with: material.name
    fill_in '型号规格', with: material.specification
    fill_in '批号', with: "测试用批号"
    select repo.name, from: '存入仓库'
    fill_in '供应商', with: purchase_supplier.name
    fill_in '重量(千克)', with: 100
    fill_in '数量', with: rand(1000)
    select '包', from: '计量单位'
    fill_in '单价(元/千克)', with: 10
    fill_in '税率(例如:4.5%的减税就填0.045)', with: rand / 10
    fill_in '运费(元)', with: 100
    fill_in '账单时间', with: 10.minutes.ago
    check 'purchase_orders[our_freight]'
    click_button '更新'
    expect(page).to have_content("成功")
    expect(page).to have_content(material.specification)
    #   查看付款单,且上面的数字也变动了
    visit expenses_path
    expense = Expense.last
    expect(page).to have_content("#{expense.order_id}")
    click_link expense.order_id
    paper_amount = find("th", text: "账面金额").find(:xpath, "./../td").text
    expect(paper_amount).to eq("100.0元")
  end

  scenario '审核采购订单' do
    purchase_order_1 = create(:purchase_order, purchase_supplier: purchase_supplier, user: user, repo: repo,
                              material: material)
    visit purchase_orders_path
    el = find('a', text: purchase_order_1.order_id)
    text = el.find(:xpath, "./../../../div[2]/div[2]").text
    expect(text).to eq("未审核")
    el.click

    click_on "通过审核"
    # 返回主页，后面的未审核字样消失
    el = find('a', text: purchase_order_1.order_id)
    text = el.find(:xpath, "./../../../div[2]/div[2]").text
    expect(text).to eq("")
    # 查看供应商
    visit purchase_supplier_path(purchase_supplier.id)

    # 检查订单数，需要付的货款，押金金额
    purchase_order_num = find("th", text: "已有订单数").find(:xpath, "./../td/a").text
    expect(purchase_order_num).to eq("1")
    total_payment_required = find("th", text: "总计货款").find(:xpath, "./../td").text
    expect(total_payment_required).to eq(purchase_order_1.total_price.to_s)
    deposit = find("th", text: "押金").find(:xpath, "./../td").text
    expect(deposit.to_f).to eq(purchase_order_1.deposit)
  end
  scenario '审核货款含运费的采购订单' do
    purchase_order_1 = create(:purchase_order, purchase_supplier: purchase_supplier, user: user, repo: repo, material: material,
                              freight: 200)
    visit purchase_orders_path
    el = find('a', text: purchase_order_1.order_id)
    text = el.find(:xpath, "./../../../div[2]/div[2]").text
    expect(text).to eq("未审核")
    el.click

    click_on "通过审核"
    # 返回主页，后面的未审核字样消失
    el = find('a', text: purchase_order_1.order_id)
    text = el.find(:xpath, "./../../../div[2]/div[2]").text
    expect(text).to eq("")
    # 查看供应商
    visit purchase_suppliers_path
    click_link(purchase_order_1.purchase_supplier.name)

    # 检查订单数，需要付的货款，押金金额
    purchase_order_num = find("th", text: "已有订单数").find(:xpath, "./../td/a").text
    expect(purchase_order_num).to eq("1")
    total_payment_required = find("th", text: "总计货款").find(:xpath, "./../td").text
    expect(total_payment_required).to eq((purchase_order_1.total_price + purchase_order_1.freight).to_s)
    deposit = find("th", text: "押金").find(:xpath, "./../td").text
    expect(deposit.to_f).to eq(purchase_order_1.deposit)
  end
  scenario '审核退货的包含运费的采购订单' do
    purchase_order_1 = create(:purchase_order, purchase_supplier: purchase_supplier, user: user, repo: repo, material: material,
                              freight: 50, is_return: true)
    visit purchase_orders_path
    el = find('a', text: purchase_order_1.order_id)
    text = el.find(:xpath, "./../../../div[2]/div[2]").text
    expect(text).to eq("未审核")
    el.click
    click_on "通过审核"
    # 返回主页，后面的未审核字样消失
    el = find('a', text: purchase_order_1.order_id)
    text = el.find(:xpath, "./../../../div[2]/div[2]").text
    expect(text).to eq("")
    # 查看供应商
    visit purchase_supplier_path(purchase_supplier.id)

    # 检查订单数，需要付的货款，押金金额
    purchase_order_num = find("th", text: "已有订单数").find(:xpath, "./../td/a").text
    expect(purchase_order_num).to eq("1")
    total_payment_required = find("th", text: "总计货款").find(:xpath, "./../td").text
    expect(total_payment_required).to eq((-(purchase_order_1.total_price + purchase_order_1.freight)).to_s)
  end
  scenario '审核退货的不包含运费的采购订单' do
    purchase_order_1 = create(:purchase_order, purchase_supplier: purchase_supplier, user: user, repo: repo, material: material,
                              freight: 50, our_freight: true, is_return: true)
    visit purchase_orders_path
    el = find('a', text: purchase_order_1.order_id)
    text = el.find(:xpath, "./../../../div[2]/div[2]").text
    expect(text).to eq("未审核")
    el.click
    click_on "通过审核"
    # 返回主页，后面的未审核字样消失
    el = find('a', text: purchase_order_1.order_id)
    text = el.find(:xpath, "./../../../div[2]/div[2]").text
    expect(text).to eq("")
    # 查看供应商
    visit purchase_supplier_path(purchase_supplier.id)

    # 检查订单数，需要付的货款，押金金额
    purchase_order_num = find("th", text: "已有订单数").find(:xpath, "./../td/a").text
    expect(purchase_order_num).to eq("1")
    total_payment_required = find("th", text: "总计货款").find(:xpath, "./../td").text
    expect(total_payment_required).to eq((-purchase_order_1.total_price).to_s)
  end
  scenario '作废订单' do
    purchase_order_1 = create(:purchase_order, purchase_supplier: purchase_supplier, user: user, repo: repo, material: material)
    visit purchase_order_path(purchase_order_1.id)
    click_on "通过审核"
    # 查看供应商
    visit purchase_supplier_path(purchase_supplier.id)

    # 检查各项数值
    purchase_order_num = find("th", text: "已有订单数").find(:xpath, "./../td/a").text
    expect(purchase_order_num).to eq("1")
    total_payment_required = find("th", text: "总计货款").find(:xpath, "./../td").text
    expect(total_payment_required).to eq(purchase_order_1.total_price.to_s)
    deposit = find("th", text: "押金").find(:xpath, "./../td").text
    expect(deposit.to_f).to eq(purchase_order_1.deposit)
    # 作废订单
    visit purchase_orders_path
    el = find('a', text: purchase_order_1.order_id)
    el.click
    click_on "作废"

    expect(page).to have_content('采购订单详情 已作废')
    # index页面上的类别里有这个作废订单
    visit purchase_orders_path
    select "已作废订单", from: "type"
    click_on "搜索"
    expect(page).to have_content(purchase_order_1.order_id)

    # 查看供应商
    visit purchase_supplier_path(purchase_supplier.id)
    # 检查订单数，需要付的货款，押金金额
    purchase_order_num = find("th", text: "已有订单数").find(:xpath, "./../td/a").text
    expect(purchase_order_num).to eq("0")
    paid = find("th", text: "总计货款").find(:xpath, "./../td").text
    expect(paid).to eq("0.0")
    deposit = find("th", text: "押金").find(:xpath, "./../td").text
    expect(deposit).to eq("0.0")
  end

  scenario "更新供应商的清算金额后，重新计算货款" do
    purchase_order_1 = create(:purchase_order, purchase_supplier: purchase_supplier, user: user, repo: repo,
                              material: material, bill_time: 1.minute.ago)
    visit purchase_order_path(purchase_order_1.id)
    click_on "通过审核"
    purchase_order_2 = create(:purchase_order, purchase_supplier: purchase_supplier, user: user, repo: repo,
                              material: material, bill_time: 1.year.ago)
    visit purchase_order_path(purchase_order_2.id)
    click_on "通过审核"

    # 查看供应商
    purchase_supplier = purchase_order_1.purchase_supplier
    visit purchase_supplier_path(purchase_supplier.id)
    # 检查订单数，需要付的货款，押金金额
    purchase_order_num = find("th", text: "已有订单数").find(:xpath, "./../td/a").text
    expect(purchase_order_num).to eq("2")
    paid = find("th", text: "总计货款").find(:xpath, "./../td").text
    expect(paid).to eq((purchase_order_1.total_price + purchase_order_1.freight + purchase_order_2.total_price + purchase_order_2.freight).to_s)
    deposit = find("th", text: "押金").find(:xpath, "./../td").text
    expect(deposit.to_f).to eq(purchase_order_1.deposit + purchase_order_2.deposit)
    #设置清算日期和金额
    click_on "编辑"
    fill_in "清算金额", with: 20000
    fill_in "清算时间", with: 10.days.ago
    click_on "更新"
    # 检查订单数，需要付的货款，押金金额
    purchase_order_num = find("th", text: "已有订单数").find(:xpath, "./../td/a").text
    expect(purchase_order_num).to eq("2")
    paid = find("th", text: "总计货款").find(:xpath, "./../td").text
    expect(paid.to_f).to eq(20000 + purchase_order_1.total_price + purchase_order_1.freight)
    deposit = find("th", text: "押金").find(:xpath, "./../td").text
    expect(deposit.to_f).to eq(purchase_order_1.deposit)
  end

end
