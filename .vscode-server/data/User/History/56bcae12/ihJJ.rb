class TagsController < ApplicationController
  def products
    @tag = Tag.find(params[:id])
    @products = @tag.products # Assuming a Tag has many Products
  end
end
