class Category < ApplicationRecord
  has_many :products

  validates :name, presence: true
end
def self.ransackable_attributes(auth_object = nil)
  ["created_at", "id", "name", "updated_at"]
end

