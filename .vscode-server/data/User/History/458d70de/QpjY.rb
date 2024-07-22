class HomeController < ApplicationController
  def index
    @available_types = Type.all
    @on_sale_products = Product.where(on_sale_status: true).limit(10)
    @recently_updated_products = Product.order(updated_at: :desc).limit(10)
  end
end
