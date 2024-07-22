class SearchController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.search(params[:keyword], params[:category])
  end
end
