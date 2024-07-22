class Person < ApplicationRecord
  belongs_to :species
  belongs_to :planet
  has_many :films, through: :characters

  validates :name, presence: true
  validates :height, numericality: true
  validates :mass, numericality: true
  validates :gender, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["species", "planet", "films"]
  end
end
