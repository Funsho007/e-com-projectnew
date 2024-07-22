class Spacecraft < ApplicationRecord
  has_and_belongs_to_many :people

  # validations
  validates :name, presence: true
  validates :model, presence: true
  validates :manufacturer, presence: true
end
