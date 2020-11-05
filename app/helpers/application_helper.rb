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
    Time.current.strftime("%Y-%m-%dT%H:%M")
  end

  def default_date_now
    Time.current.strftime("%Y-%m-%d")
  end

end
