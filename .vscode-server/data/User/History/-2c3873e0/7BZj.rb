class CheckoutController < ApplicationController
  before_action :set_cart

  def index
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.order_date = Time.current
    @order.status = 'new'
    @order.add_cart_items(@cart)
    @order.calculate_total

    if @order.save
      session[:cart_id] = nil # Clear the cart
      redirect_to checkout_success_path, notice: 'Your order has been placed successfully.'
    else
      render :index
    end
  end

  def success
  end

  private

  def order_params
    params.require(:order).permit(:customer_id, :address, :payment_method, :gst, :hst, :pst)
  end

  def set_cart
    @cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end
end
