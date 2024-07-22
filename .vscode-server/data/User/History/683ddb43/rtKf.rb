class Starship < ApplicationRecord
  has_many :films

  validates :name, presence: true
  validates :model, presence: true
  validates :manufacturer, presence: true
  validates :cost_in_credits, numericality: { only_integer: true }

  def self.ransackable_associations(auth_object = nil)
    ["films"]
  end
end
