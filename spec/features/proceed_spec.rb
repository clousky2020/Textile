require 'rails_helper'


describe 'proceed' do
  let(:user) {create(:user)}
  let!(:sale_customer) {create(:sale_customer)}
  before do
    login_in(user)
  end
  describe "收款单的CRUD" do
    scenario '创建一张新的收款单' do
      visit '/'
      click_link '填写新的收款单'
      select sale_customer.name, from: '客户名称'
      fill_in '账面金额', with: '210.0'
      fill_in '实际金额', with: '210.0'
      select '银行', from: '账户所属'
      fill_in '经手人ID', with: '1'
      fill_in '账单时间', with: 10.minutes.ago
      click_button '创建'
      expect(page).to have_content("创建成功")
    end

    scenario '审核收款单并检查收款金额是否记入客户' do
      proceed = create(:proceed, user: user, sale_customer: sale_customer)
      visit proceeds_path

      el = find('a', text: proceed.order_id)
      text = el.find(:xpath, "./../../div[2]/div[2]").text
      expect(text).to eq("未审核")
      el.click
      click_on "通过审核"
      # 返回主页，后面的未审核字样消失
      visit proceeds_path

      el = find('a', text: proceed.order_id)
      text = el.find(:xpath, "./../../div[2]/div[2]").text
      expect(text).to eq("")
      #   检查客户界面是否有这笔收款单的内容
      visit sale_customer_path(sale_customer.id)

      # 检查各项数值
      proceed_num = find("th", text: "已有收款单数").find(:xpath, "./../td/a").text
      expect(proceed_num).to eq("1")
      received = find("th", text: "已收款项").find(:xpath, "./../td").text
      expect(received).to eq(proceed.paper_amount.to_s)
    end

    scenario '作废收款单并检查收款金额是否从客户处扣除了' do
      proceed = create(:proceed, user: user, sale_customer: sale_customer)
      visit proceed_path(proceed.id)
      click_on "通过审核"

      # 查看客户
      visit sale_customer_path(sale_customer.id)
      # 检查各项数值
      proceed_num = find("th", text: "已有收款单数").find(:xpath, "./../td/a").text
      expect(proceed_num).to eq("1")
      received = find("th", text: "已收款项").find(:xpath, "./../td").text
      expect(received).to eq(proceed.paper_amount.to_s)

      visit proceeds_path
      click_on proceed.order_id
      click_on "作废"
      expect(page).to have_content("#{sale_customer.name}的订单#{proceed.order_id}已作废")
      # index页面上的类别里有这个作废订单
      visit proceeds_path
      select "已作废订单", from: "type"
      click_on "搜索"
      expect(page).to have_content(proceed.order_id)
      # 查看客户
      visit sale_customer_path(sale_customer.id)
      # 检查各项数值
      proceed_num = find("th", text: "已有收款单数").find(:xpath, "./../td/a").text
      expect(proceed_num).to eq("0")
      received = find("th", text: "已收款项").find(:xpath, "./../td").text
      expect(received).to eq('0.0')

    end

    scenario '删除未审核的收款单' do
      proceed = create(:proceed, user: user, sale_customer: sale_customer)
      visit proceeds_path
      el = find('a', text: proceed.order_id)
      text = el.find(:xpath, "./../../div[2]/div[2]").text
      expect(text).to eq("未审核")
      delete_link = el.find(:xpath, "./../../div[3]/div[2]/a")
      expect(delete_link.text).to eq("删除")
      delete_link.click
      expect(page).to have_content("#{sale_customer.name}的订单#{proceed.order_id}已删除")
      visit proceeds_path
      expect(page).not_to have_content(proceed.order_id)
    end
  end

  describe "收款列表的查询" do
    let!(:proceeds) {create_list(:proceed, 10, user: user, sale_customer: sale_customer)}
    before do
      visit proceeds_path
    end

    scenario "未作废订单-已作废订单" do
      select '未作废订单', from: 'type'
      select '账单时间降序', from: 'order'
      click_button '搜索'
      proceeds.each do |proceed|
        expect(page).to have_content(proceed.order_id)
        proceed.order_declare_invalid(user)
      end

      select '未作废订单', from: 'type'
      select '账单时间升序', from: 'order'
      click_button '搜索'
      proceeds.each do |proceed|
        expect(page).not_to have_content(proceed.order_id)
      end
      expect(page).to have_content("空空如也")

      select '已作废订单', from: 'type'
      select '订单号', from: 'order'
      click_button '搜索'
      proceeds.each do |proceed|
        expect(page).to have_content(proceed.order_id)
      end
    end

    scenario "未审核订单-已审核订单" do
      select '已审核订单', from: 'type'
      select '账单时间升序', from: 'order'
      click_button '搜索'
      proceeds.each do |proceed|
        expect(page).not_to have_content(proceed.order_id)
      end
      expect(page).to have_content("空空如也")

      select '未审核订单', from: 'type'
      select '账单时间降序', from: 'order'
      click_button '搜索'
      proceeds.each do |proceed|
        expect(page).to have_content(proceed.order_id)
        proceed.pass_check_result(user)
      end

      select '已审核订单', from: 'type'
      select '订单号', from: 'order'
      click_button '搜索'
      proceeds.each do |proceed|
        expect(page).to have_content(proceed.order_id)
      end
    end

    scenario "退货单" do
      select '退货单', from: 'type'
      select '账单时间升序', from: 'order'
      click_button '搜索'
      proceeds.each do |proceed|
        expect(page).not_to have_content(proceed.order_id)
      end
      expect(page).to have_content("空空如也")

      proceeds.each do |proceed|
        proceed.is_return = true
        proceed.save
      end

      select '退货单', from: 'type'
      select '账单时间降序', from: 'order'
      click_button '搜索'
      proceeds.each do |proceed|
        expect(page).to have_content(proceed.order_id)
      end

      select '退货单', from: 'type'
      select '订单号', from: 'order'
      click_button '搜索'
      proceeds.each do |proceed|
        expect(page).to have_content(proceed.order_id)
      end
    end

    describe "特定名称" do
      scenario "客户名字" do
        fill_in 'search', with: proceeds[0].sale_customer.name
        select '未作废订单', from: 'type'
        click_button '搜索'
        expect(page).to have_content(proceeds[0].sale_customer.name)
      end
      scenario "备注" do
        fill_in 'search', with: proceeds[0].remark
        select '未作废订单', from: 'type'
        click_button '搜索'
        expect(page).to have_content(proceeds[0].remark)
      end
      scenario "订单号" do
        fill_in 'search', with: proceeds[0].order_id
        select '未作废订单', from: 'type'
        click_button '搜索'
        expect(page).to have_content(proceeds[0].order_id)
      end
    end
  end

end
