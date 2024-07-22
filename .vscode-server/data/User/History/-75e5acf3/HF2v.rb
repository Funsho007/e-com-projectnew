class Film < ApplicationRecord
  has_and_belongs_to_many :people

  validates :title, presence: true
  # validates :film_id, optional: true
end
