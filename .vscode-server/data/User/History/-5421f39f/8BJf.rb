class Person < ApplicationRecord
  belongs_to :planet
  belongs_to :species
  has_and_belongs_to_many :films
  has_and_belongs_to_many :spacecrafts
  has_and_belongs_to_many :vehicles

  validates :name, presence: true
  validates :birth_year, presence: true
end
