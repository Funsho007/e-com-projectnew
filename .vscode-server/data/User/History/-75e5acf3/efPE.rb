class Film < ApplicationRecord
  has_many :characters
  has_many :people, through: :characters

  validates :title, presence: true
  validates :episode_id, presence: true, uniqueness: true
  validates :opening_crawl, presence: true
  validates :director, presence: true
  validates :producer, presence: true
  validates :release_date, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "director", "episode_id", "film_id", "id", "opening_crawl", "producer", "release_date", "title", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["characters", "people"]
  end
end
