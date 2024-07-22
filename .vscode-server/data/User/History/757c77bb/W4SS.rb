class CartItemsController < ApplicationController
  before_action :set_cart, only: [:create, :update, :destroy]

  def create
    product = Product.find(params[:product_id])
    @cart_item = @cart.cart_items.find_or_initialize_by(product: product)

    if @cart_item.new_record?
      @cart_item.quantity = cart_item_params[:quantity]
    else
      @cart_item.quantity += cart_item_params[:quantity].to_i
    end

    if @cart_item.save
      redirect_to @cart, notice: 'Product was successfully added to the cart.'
    else
      redirect_to product, alert: 'There was an issue adding the product to the cart.'
    end
  end

  def update
    @cart_item = @cart.cart_items.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to @cart, notice: 'Cart item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @cart_item = @cart.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to @cart, notice: 'Product was successfully removed from the cart.'
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