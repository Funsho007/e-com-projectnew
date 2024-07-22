class Starship < ApplicationRecord
  has_and_belongs_to_many :people

  validates :name, presence: true
  # validates :starship_id, uniqueness: true
end
