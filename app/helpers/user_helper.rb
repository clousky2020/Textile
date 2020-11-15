module UserHelper

  # 根据订单是否通过报销，改变框内的颜色
  def order_status_css(object)
    if object.reimbursed
      "alert-success"
    else
      "alert-warning"
    end
  end

end
