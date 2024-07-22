class CheckoutController < ApplicationController
  def create
    @order = Order.new(order_params)
    @order.cart = current_cart

    if @order.save
      session[:cart_id] = nil # Clear the cart
      redirect_to checkout_success_path, notice: 'Your order has been placed successfully.'
    else
      render :index
    end
  end

  def index
    @cart = current_cart
  end

  def success
  end

  private

  def order_params
    params.require(:order).permit(:customer_id, :address, :payment_method)
  end

  def current_cart
    Cart.find(session[:cart_id])
  end
end
