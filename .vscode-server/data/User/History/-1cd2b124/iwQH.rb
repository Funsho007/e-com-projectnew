class Person < ApplicationRecord
  belongs_to :species
  belongs_to :planet

  has_many :characters
  has_many :films, through: :characters

  validates :name, presence: true
  validates :species_id, presence: true
  validates :planet_id, presence: true
  validates :birth_year, presence: true
  validates :gender, presence: true
end
