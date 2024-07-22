class Species < ApplicationRecord
  has_many :people

  validates :name, presence: true
  validates :species_id, uniqueness: true
end
