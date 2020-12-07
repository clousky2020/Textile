module OutputsHelper
  # 今天的记录，特别颜色显示
  def daliy_css(object)
    if object.output_date == Time.current.localtime.to_date
      "daily_output"
    else
      ""
    end
  end

end
