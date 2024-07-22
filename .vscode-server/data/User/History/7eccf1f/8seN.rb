class Vehicle < ApplicationRecord
  has_and_belongs_to_many :people

  validates :name, presence: true
  # valizdates :vehicle_id, uniqueness: true
end
