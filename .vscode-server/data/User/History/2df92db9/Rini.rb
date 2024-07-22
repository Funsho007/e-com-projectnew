class Planet < ApplicationRecord
  has_many :people
  
  validates :name, presence: true
  validates :planet_id, uniqueness: true
end
