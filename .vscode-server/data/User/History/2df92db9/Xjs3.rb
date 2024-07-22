class Planet < ApplicationRecord
  has_many :people

  def self.ransackable_associations(auth_object = nil)
    ["people"]
  end
end
