module ApplicationHelper

  def full_title(page_title = "")
    base_title = "顾丰纺织"
    if page_title.empty?
      base_title
    else
      page_title + "|" + base_title
    end
  end

  def default_time_now
    Time.current.localtime.strftime("%Y-%m-%dT%H:%M")
  end

  def default_date_now
    Time.current.localtime.strftime("%Y-%m-%d")
  end

  # 根据订单是否通过审核，改变框内的颜色
  def check_status_css(object)
    if !object.check_status
      status = "alert-danger"
    else
      status = "alert-success"
    end
  end

end
