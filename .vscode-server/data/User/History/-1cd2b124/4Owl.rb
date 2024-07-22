class Person < ApplicationRecord
  belongs_to :planet
  belongs_to :species, optional: true
  has_and_belongs_to_many :films
  has_and_belongs_to_many :starships
  has_and_belongs_to_many :vehicles

  validates :name, presence: true
  validates :person_id, uniqueness: true
end
