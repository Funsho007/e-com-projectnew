class Film < ApplicationRecord
  has_many :characters
  has_many :people, through: :characters
  has_many :starships, through: :characters
  has_many :planets, through: :characters

  validates :title, presence: true
  validates :episode_id, presence: true, uniqueness: true
  validates :opening_crawl, presence: true
  validates :director, presence: true
  validates :producer, presence: true
  validates :release_date, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[title episode_id director producer release_date created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[characters people starships planets]
  end
end
