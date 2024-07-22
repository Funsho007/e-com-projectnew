class SearchController < ApplicationController
  def index
    @categories = Category.all
    @products = if params[:category].present?
                  Product.where('title ILIKE ? OR description ILIKE ?', "%#{params[:keyword]}%", "%#{params[:keyword]}%")
                         .where(category_id: params[:category])
                else
                  Product.where('title ILIKE ? OR description ILIKE ?', "%#{params[:keyword]}%", "%#{params[:keyword]}%")
                end
  end
end
