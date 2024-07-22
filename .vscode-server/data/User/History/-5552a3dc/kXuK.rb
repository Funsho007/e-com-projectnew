class StaticPagesController < ApplicationController
  class StaticPage < ApplicationRecord
    validates :title, presence: true, uniqueness: true
    validates :content, presence: true
  end
  end
end
