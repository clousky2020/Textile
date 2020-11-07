class DashboardController < ApplicationController


  def index
    # 未审核的内容
    @not_pass_purchase_orders = PurchaseOrder.where(check_status: false)
    @not_pass_sale_orders = SaleOrder.where(check_status: false)
    @not_pass_proceeds = Proceed.where(check_status: false)
    @not_pass_expenses = Expense.where(check_status: false)

    #今天的单子
    # @daily_purchase_orders = PurchaseOrder.where(created_at: (Time.now.midnight-1.day)..Time.now.midnight)
    # @daily_sale_orders = SaleOrder.where(created_at: (Time.now.midnight-1.day)..Time.now.midnight)
    # @daily_proceeds = Proceed.where(created_at: (Time.now.midnight-1.day)..Time.now.midnight)
    # @daily_expenses = Expense.where(created_at: (Time.now.midnight-1.day)..Time.now.midnight)
  end

  def check_sale_order
    @sale_orders = SaleOrder.check_date(params[:start_date], params[:end_date])
    @proceeds = Proceed.check_date(params[:start_date], params[:end_date])
  end



end
