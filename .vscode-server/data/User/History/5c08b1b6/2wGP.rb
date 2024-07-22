# app/models/planet.rb
class Planet < ApplicationRecord
  validates :name, presence: true
  validates :diameter, numericality: { greater_than: 0 }
  validates :rotation_period, numericality: { greater_than: 0 }
end

  primary_abstract_class

end
