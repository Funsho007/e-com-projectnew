class Planet < ApplicationRecord
  has_many :people

  validates :name, presence: true
  validates :diameter, numericality: { only_integer: true, greater_than: 0 }

end
