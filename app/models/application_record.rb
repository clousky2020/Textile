class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true


  #根据订单的创建时间，生成订单号
  def generate_order_id
    self.update(order_id: self.created_at.localtime.strftime("%Y%m%d%H%M%S") + self.id.to_s)
  end

  #计算订单税后总价
  def calcuate_total_price
    if self.price && self.weight
      self.tax_rate = 0 if !self.tax_rate
      self.update_columns(total_price: self.price * self.weight * (1 - self.tax_rate))
    end
  end

  #报销单已报销
  def pass_reimburse_expense
    self.update(need_reimburse: false, reimbursed: true)
  end

  #订单通过审核
  def pass_check_result(current_user)
    self.update(check_status: true, check_time: Time.now, check_person: current_user.name)
  end

  #初始化订单审核状态
  def check_result_initial
    self.update_columns(check_status: false)
  end

  #作废订单
  def order_declare_invalid(current_user)
    self.update_columns(is_invalid: true, declare_invalid_person: current_user.name, declare_invalid_time: Time.now)
  end

  #订单创建人
  def created_person
    begin
      self.update(create_person: current_user.name)
    rescue
      self.update(create_person: User.find(self.user_id).name)
    end
  end

  #查找name的值
  def self.search_name(term)
    where('name LIKE ?', "%#{term.strip}%")
  end

  #查找specification的值
  def self.search_specification(term)
    where('specification LIKE ?', "%#{term.strip}%")
  end


  # 按月份计算金额
  def self.check_date(start_date, end_date, option)
    orders = self.where(bill_time: start_date..end_date).select(:bill_time, option).where(is_invalid: false, check_status: true)
    h = Hash.new
    orders.each do |order|
      if end_date.to_i - start_date.to_i > 30
        bill_date = order.bill_time.strftime("%Y-%m")
      else
        bill_date = order.bill_time.strftime("%Y-%m-%d")
      end
      total_price = order["#{option}"]
      if h.has_key? bill_date
        h[bill_date] += total_price
      else
        h.store(bill_date, total_price)
      end
    end
    h
  end

  # 获得时间内的交易额,降序排序
  def self.check_top_to_hash(start_date, end_date, attribute1, attribute2)
    # 获取符合条件的订单
    orders = self.where(bill_time: start_date..end_date, is_invalid: false, check_status: true)
    # 新建一个hash
    h = Hash.new
    # 遍历
    orders.each do |order|
      # hash里面已有名字
      if h.has_key? order.send(attribute1).send(attribute2)
        # 添加新的订单总值
        h[order.send(attribute1).send(attribute2)] += order.total_price
      else
        # 把名字和订单总值加入hash
        h.store(order.send(attribute1).send(attribute2), order.total_price)
      end
    end
    # 排序
    h.sort {|a, b| b[1] <=> a[1]}.to_h
  end


end
