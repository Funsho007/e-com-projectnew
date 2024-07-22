class Film < ApplicationRecord
  has_and_belongs_to_many :people

  validates :title, presence: true
  validates :id, uniqueness: true

  def self.search(term)
    if term
      where('title ILIKE ? OR director ILIKE ? OR producer ILIKE ?', "%#{term}%", "%#{term}%", "%#{term}%")
    else
      all
    end
  end
end
