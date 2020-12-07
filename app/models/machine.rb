class Machine < ApplicationRecord
  has_many :outputs
  validates :machine_id, uniqueness: true

end
