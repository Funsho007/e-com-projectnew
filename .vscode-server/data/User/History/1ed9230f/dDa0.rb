class Species < ApplicationRecord
  belongs_to :planet
  has_many :people

  validates :name, presence: true
  validates :classification, presence: true
  validates :designation, presence: true
  validates :language, presence: true
  validates :average_height, numericality: true
  validates :average_lifespan, numericality: true
  validates :species_id, uniqueness: true

  def self.ransackable_associations(auth_object = nil)
    ["planet", "people"]
  end
end
