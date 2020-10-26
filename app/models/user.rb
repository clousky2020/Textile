class User < ApplicationRecord

  has_one :repo

  has_many :purchase_orders
  has_many :sale_orders
  has_many :products
  has_many :materials


  rolify
  has_secure_password
  # after_create :assign_default_role

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, presence: true,
            length: {maximum: 10, message: "用户名长度超出10个字符"},
            uniqueness: {message: "已有这个用户名"}
  validates :email, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  #创建用户后，设定初始的role
  def assign_default_role
    self.add_role(:newuser) if self.roles.blank?
  end

  #给账户上锁
  def get_locked
    if self.is_lock
      self.update_columns(is_lock: false)
    else
      self.update_columns(is_lock: true)
      self.update_columns(lock_time: Time.now)
    end
  end


end
