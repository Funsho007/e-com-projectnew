class Province < ApplicationRecord
  validates :name, presence: true
  validates :tax_type, presence: true
  validates :gst, :pst, :hst, :qst, numericality: true

  def self.ransackable_attributes(auth_object = nil)
    ["name", "tax_type", "gst", "pst", "hst", "qst", "created_at", "updated_at"]
  end
end
