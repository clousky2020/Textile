class ChangeMachine < ApplicationRecord

  validates :price, :change_person, :change_date, :machine_id, presence: true
  validates :change_date, uniqueness: {scope: :machine_id}

  def self.search(search)
    if search
      where("change_person LIKE :term or contacts LIKE :term or  machine_type LIKE :term or  change_to_specification LIKE :term or remark LIKE :term or machine_id = :term_i ", term: "%#{search}%", term_i: search.to_i)
    else
      all
    end
  end
end
