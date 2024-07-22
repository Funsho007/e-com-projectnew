class StaticPagesController < ApplicationController
  def show
    @static_page = StaticPage.find_by(title: params[:title])
  end
end
