# app/controllers/static_pages_controller.rb

class StaticPagesController < ApplicationController
  def show
    @static_page = StaticPage.find_by(title: params[:title])
    if @static_page.nil?

  end
end
end
