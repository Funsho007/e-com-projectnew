# app/models/species.rb

class Species < ApplicationRecord
  belongs_to :planet

  has_many :people

  validates :name, presence: true
  validates :classification, presence: true
  validates :designation, presence: true
  validates :language, presence: true
  validates :average_height, presence: true
  validates :average_lifespan, presence: true
  validates :species_id, uniqueness: true
end
