class Film < ApplicationRecord
  has_and_belongs_to_many :people

  validates :title, presence: true
  validates :id, uniqueness: true

  def self.search(term)
    if term
      where('LOWER(title) LIKE ? OR LOWER(director) LIKE ? OR LOWER(producer) LIKE ?', "%#{term.downcase}%", "%#{term.downcase}%", "%#{term.downcase}%")
    else
      all
    end
  end
end
