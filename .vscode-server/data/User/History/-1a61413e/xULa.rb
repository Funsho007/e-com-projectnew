class Character < ApplicationRecord
  belongs_to :film
  belongs_to :person

  validates :film_id, presence: true
  validates :person_id, presence: true
end
