class Species < ApplicationRecord
  has_many :people

  validates :name, presence: true
  validates :average_lifespan, numericality: { only_integer: true, greater_than: 0 }
end
