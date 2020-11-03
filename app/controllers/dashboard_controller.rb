class DashboardController < ApplicationController


  def index
    # 还未审核的订单
    @purchase_orders = PurchaseOrder.where(check_status: false)

  end

end
