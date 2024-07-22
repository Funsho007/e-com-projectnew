class Film < ApplicationRecord
  has_many :characters
  has_many :people, through: :characters

  validates :title, presence: true
  validates :episode_id, numericality: { only_integer: true, uniqueness: true }
  validates :director, presence: true
  validates :producer, presence: true
  validates :release_date, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["characters", "people"]
  end
end
