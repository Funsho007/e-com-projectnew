class CartsController < ApplicationController
  before_action :set_cart

  def show
  end

  def update
    @cart_item = @cart.cart_items.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to cart_path, notice: 'Cart item was successfully updated.'
    else
      redirect_to cart_path, alert: 'There was an issue updating the cart item.'
    end
  end

  def remove
    @cart_item = @cart.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path, notice: 'Product was successfully removed from the cart.'
  end

  private

  def set_cart
    @cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end
end
