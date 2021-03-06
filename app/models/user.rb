class User < ApplicationRecord
  has_many :repo
  has_many :purchase_orders
  has_many :sale_orders
  has_many :products
  has_many :materials
  has_many :expenses
  has_many :proceeds
  has_many :comments
  has_many :role_assignments, dependent: :destroy
  has_many :roles, through: :role_assignments
  delegate :computed_permissions, to: :role
  has_secure_password
  # after_create :assign_default_role

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, presence: true,
            length: {maximum: 10},
            uniqueness: true
  validates :email, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false},
            allow_blank: true

  def computed_permissions
    roles.map(&:computed_permissions).reduce(RoleCore::ComputedPermissions.new, &:concat)
  end

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
