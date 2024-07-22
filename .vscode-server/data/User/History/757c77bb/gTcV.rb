class CartItemsController < ApplicationController
  before_action :set_cart
  before_action :set_cart_item, only: [:show, :update, :destroy]

  def show
    # @cart_item is set by the set_cart_item before_action
  end

  def create
    product = Product.find(params[:cart_item][:product_id])
    @cart_item = @cart.cart_items.find_or_initialize_by(product: product)

    if @cart_item.new_record?
      @cart_item.quantity = cart_item_params[:quantity]
    else
      @cart_item.quantity += cart_item_params[:quantity].to_i
    end

    if @cart_item.save
      redirect_to cart_path, notice: 'Product was successfully added to the cart.'
    else
      redirect_to product, alert: 'There was an issue adding the product to the cart.'
    end
  end

  def update
    if @cart_item.update(cart_item_params)
      redirect_to cart_path, notice: 'Cart item was successfully updated.'
    else
      redirect_to cart_path, alert: 'There was an issue updating the cart item.'
    end
  end

  def destroy
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

  def set_cart_item
    @cart_item = @cart.cart_items.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end
end
