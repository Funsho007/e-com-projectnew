class PagesController < ApplicationController
  def about
    @about_api_description = ABOUT_API_DESCRIPTION
  end
end
