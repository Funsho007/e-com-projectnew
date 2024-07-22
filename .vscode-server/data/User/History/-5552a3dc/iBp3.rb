# app/models/static_page.rb

class StaticPage < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :content, presence: true
end
