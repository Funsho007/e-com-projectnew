class Film < ApplicationRecord
  has_and_belongs_to_many :people

  # validations
  validates :title, presence: true
  validates :episode_id, presence: true, numericality: { only_integer: true }
  validates :release_date, presence: true

end
