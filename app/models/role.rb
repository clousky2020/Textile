class Role < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles

  belongs_to :resource,
             :polymorphic => true,
             :optional => true


  validates :resource_type,
            :inclusion => {:in => Rolify.resource_types},
            :allow_nil => true

  scopify

  Roles = {"buyer": "采购员", "admin": "管理员", "sale": "销售员", "warehouse": "仓管员", "accounting": "财务会计"}

  def to_chinese
    Roles[self.name.to_sym]
  end


end
