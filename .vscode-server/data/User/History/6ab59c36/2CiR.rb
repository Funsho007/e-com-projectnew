class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Whitelist searchable attributes for Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[id email created_at updated_at current_sign_in_at sign_in_count]
  end

  # If you want to allow associations to be searchable as well
  def self.ransackable_associations(auth_object = nil)
    %w[] # Add associations here if needed
  end

  # Devise requires serialize_from_session method for session management
  def self.serialize_from_session(key, salt)
    record = find_by(id: key)
    record if record && record.authenticatable_salt == salt
  end
end
