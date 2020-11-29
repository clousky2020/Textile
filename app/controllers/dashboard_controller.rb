class DashboardController < ApplicationController

  def index
    # 未审核的内容
    @not_pass_purchase_orders = PurchaseOrder.where(check_status: false, is_invalid: false)
    @not_pass_sale_orders = SaleOrder.where(check_status: false, is_invalid: false)
    @not_pass_proceeds = Proceed.where(check_status: false, is_invalid: false)
    @not_pass_expenses = Expense.where(check_status: false, is_invalid: false)
    @need_reimburses = Expense.where(is_invalid: false, need_reimburse: true)
    @need_pass_settle = ChangeMachine.where(is_settle: false)
    # 最近一星期的单子数
    @last_week_purchase_orders = PurchaseOrder.where(is_invalid: false).where("bill_time > ?", Time.current.midnight - 7.days)
    @last_week_sale_orders = SaleOrder.where(is_invalid: false).where("bill_time > ?", Time.current.midnight - 7.days)
    @last_week_proceeds = Proceed.where(is_invalid: false).where("bill_time > ?", Time.current.midnight - 7.days)
    @last_week_expenses = Expense.where(is_invalid: false).where("bill_time > ?", Time.current.midnight - 7.days)
  end

  def check_orders_money
    @sale_orders = SaleOrder.check_date(params[:start_date], params[:end_date], :total_price)
    @proceeds = Proceed.check_date(params[:start_date], params[:end_date], :actual_amount)
    @purchase_orders = PurchaseOrder.check_date(params[:start_date], params[:end_date], :total_price)
    @expenses = Expense.check_date(params[:start_date], params[:end_date], :actual_amount)
    @ratio = Array.new
    @ratio << @proceeds.values.sum << @expenses.values.sum
  end

  def check_trade_top
    @top_purchase_orders = PurchaseOrder.check_top_to_hash(params[:start_date], params[:end_date], 'purchase_supplier', 'name')
    @top_sale_orders = SaleOrder.check_top_to_hash(params[:start_date], params[:end_date], 'sale_customer', 'name')
  end

  def check_expense_ratio
    @expenses = Expense.check_ratio(params[:start_date], params[:end_date])
  end

  def check_purchase_supplier
    purchase_supplier = PurchaseSupplier.find(params[:purchase_supplier_id].to_i)
    @purchase_orders = purchase_supplier.check_broken_line(params[:start_date], params[:end_date])
    @expenses = purchase_supplier.check_expenses(params[:start_date], params[:end_date])
  end

  def check_sale_customer
    sale_customer = SaleCustomer.find(params[:sale_customer_id].to_i)
    @sale_orders = sale_customer.check_broken_line(params[:start_date], params[:end_date])
    @proceeds = sale_customer.check_proceed(params[:start_date], params[:end_date])
  end

  # 删除所有该用户的新手引导记录
  def intro_clear
    store_referrer_location
    ActiveRecord::Base.connection.execute("delete from intro_histories where user_id =#{params[:id]} ")
    redirect_back_referrer_for root_url
  end
end
