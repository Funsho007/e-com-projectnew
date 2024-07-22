class CartItemsController < ApplicationController
  def update
    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to cart_path, notice: 'Cart item updated successfully.'
    else
      redirect_to cart_path, alert: 'Failed to update cart item.'
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path, notice: 'Cart item removed successfully.'
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
