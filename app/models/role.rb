class Role < RoleCore ::Role
  has_many :role_assignments, dependent: :destroy
  has_many :users, through: :role_assignments


  # RESERVED = [:admin, :guest]
  # has_and_belongs_to_many :staffs, :join_table => :staffs_roles
  #
  # has_many :role_resources, dependent: :destroy
  #
  # def self.all_without_reserved
  #   self.all.reject do |role|
  #     RESERVED.include?(role.name)
  #   end
  # end

  Roles = {"buyer": "采购员", "admin": "管理员", "saler": "销售员", "director": "主管", "accounting": "财务会计"}

  def to_chinese
    Roles[self.name.to_sym]
  end

end
