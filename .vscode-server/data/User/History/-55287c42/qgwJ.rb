class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def filter_by_category
    @products = if params[:type_id].present?
                  Product.where(type_id: params[:type_id])
                else
                  Product.all
                end

    render :index
  end
end
