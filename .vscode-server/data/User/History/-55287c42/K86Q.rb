class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def filter
    @products = case params[:filter]
                when 'new'
                  Product.where('created_at >= ?', 1.month.ago)
                when 'on_sale'
                  Product.where(on_sale: true)
                else
                  Product.all
                end

    render :index
  end
end
