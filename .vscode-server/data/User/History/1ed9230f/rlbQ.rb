class Species < ApplicationRecord
  has_many :people

  validates :name, presence: true
  validates :classification, presence: true
  validates :species_id, uniqueness: true
end
