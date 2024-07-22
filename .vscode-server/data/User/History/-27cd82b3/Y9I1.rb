class Province < ApplicationRecord
  validates :name, presence: true
  validates :tax_type, presence: true
  validates :gst, :pst, :hst, numericality: true
end
