class Spacecraft < ApplicationRecord
  has_and_belongs_to_many :people

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :serial_number, presence: true, uniqueness: true
  validates :description, presence: true, length: { minimum: 10 }
  validate :at_least_one_person_associated

  private

  def at_least_one_person_associated
    errors.add(:people, 'must have at least one associated person') if people.empty?
  end
end
