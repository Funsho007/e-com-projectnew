class AdminUser < ApplicationRecord
  # ...

  # Whitelist searchable attributes for Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[id email created_at updated_at current_sign_in_at sign_in_count]
  end

  # If you want to allow associations to be searchable as well
  def self.ransackable_associations(auth_object = nil)
    %w[] # Add associations here if needed
  end

  # ...
end
