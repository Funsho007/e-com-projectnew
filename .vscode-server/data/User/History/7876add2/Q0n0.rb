class Film < ApplicationRecord
  has_and_belongs_to_many :people

  # Validations
  validates :title, presence: true, uniqueness: true
  validates :release_date, presence: true
  validates :description, presence: true, length: { minimum: 10 }

  # Custom validation to ensure at least one person is associated
  validate :at_least_one_person_associated

  private

  def at_least_one_person_associated
    errors.add(:people, 'must have at least one associated person') if people.empty?
  end
end

