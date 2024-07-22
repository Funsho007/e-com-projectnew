class Customer < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[id name email created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[orders] # Include any associations that you want to be searchable
  end
end
