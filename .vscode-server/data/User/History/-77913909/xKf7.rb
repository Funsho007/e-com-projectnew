class OtherUser < ApplicationRecord
  # ...

  # Whitelist searchable attributes for Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[id name email created_at updated_at]
  end

  # If you want to allow associations to be searchable as well
  def self.ransackable_associations(auth_object = nil)
    %w[associated_model1 associated_model2] # Replace with actual associations
  end

  # ...
end
