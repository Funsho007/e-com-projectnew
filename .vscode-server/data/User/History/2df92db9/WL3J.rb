class Planet < ApplicationRecord
  has_many :people

  validates :name, presence: true
  validates :climate, presence: true
  validates :terrain, presence: true
  validates :population, numericality: { only_integer: true }

  def self.ransackable_associations(auth_object = nil)
    ["people"]
  end
end
