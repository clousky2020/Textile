class Repo < ApplicationRecord
  has_many :sale_orders
  has_many :purchase_orders
  belongs_to :user


  validates :name, uniqueness: true
  validates :name, :address, presence: true

end
