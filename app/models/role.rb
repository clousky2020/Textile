class Role < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles

  belongs_to :resource,
             :polymorphic => true,
             :optional => true


  validates :resource_type,
            :inclusion => {:in => Rolify.resource_types},
            :allow_nil => true

  scopify



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
