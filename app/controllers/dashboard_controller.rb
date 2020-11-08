class DashboardController < ApplicationController


  def index
    # 未审核的内容
    @not_pass_purchase_orders = PurchaseOrder.where(check_status: false, is_invalid: false)
    @not_pass_sale_orders = SaleOrder.where(check_status: false, is_invalid: false)
    @not_pass_proceeds = Proceed.where(check_status: false, is_invalid: false)
    @not_pass_expenses = Expense.where(check_status: false, is_invalid: false)
    @need_reimburses = Expense.where(check_status: false, is_invalid: false, need_reimburse: true)
  end

  def check_sale_proceed
    @sale_orders = SaleOrder.check_date(params[:start_date], params[:end_date], :total_price)
    @proceeds = Proceed.check_date(params[:start_date], params[:end_date], :paper_amount)
    @purchase_orders = PurchaseOrder.check_date(params[:start_date], params[:end_date], :total_price)
    @expenses = Expense.check_date(params[:start_date], params[:end_date], :paper_amount)
    @ratio=Array.new
    @ratio << @proceeds.values.sum << @expenses.values.sum
  end

  def check_purchase_expense
    @purchase_orders = PurchaseOrder.check_date(params[:start_date], params[:end_date], :total_price)
    @expenses = Expense.check_date(params[:start_date], params[:end_date], :paper_amount)
  end

  def check_expense_proceed
    @expenses = Expense.where(bill_time: params[:start_date]..params[:end_date]).where(is_invalid: false, check_status: true)
    @proceeds = Proceed.where(bill_time: params[:start_date]..params[:end_date]).where(is_invalid: false, check_status: true)
  end
end
