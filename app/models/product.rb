class Product < ApplicationRecord
  belongs_to :sale_order

  # validates :name, presence: true, uniqueness: {scope: :specification}
end
