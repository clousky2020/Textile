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

  def str_date(object)
    object.strftime("%Y-%m-%d")
  end

  def str_time(object)
    object.strftime("%Y-%m-%d %H:%M")
  end

  # 根据订单的各种状态，改变框内的颜色
  def check_status_css(object)
    if object.is_invalid
      "alert-warning"
    elsif !object.check_status
      "alert-danger"
    else
      "alert-success"
    end
  end

  # 根据设置是否开启，改变框内的颜色
  def param_status_css(object)
    if object.status
      "alert-success"
    else
      nil
    end
  end

  def param_check(name)
    settle = Param.find_by(name: name)
    if settle && settle.status
      "已开启#{name},#{settle.description}"
    else
      nil
    end
  end

end
