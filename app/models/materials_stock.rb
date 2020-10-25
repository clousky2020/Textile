class MaterialsStock < ApplicationRecord
  has_many :materials
  belongs_to :repo
end
