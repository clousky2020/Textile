class Repo < ApplicationRecord
  has_many :materials_stocks
  has_many :products_stocks
  has_many :sale_orders
  has_many :purchase_orders
  belongs_to :user


  validates :name, uniqueness: true


    # after_create :update_admin_name
    # after_update :update_admin_name
    #
    #
    # #根据字段admin_id更新字段admin_name的值
    # def update_admin_name
    #   self.update_columns(admin_name: User.find(self.admin_id).name)
    # end


end
