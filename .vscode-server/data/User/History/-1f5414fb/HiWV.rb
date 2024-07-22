class CheckoutController < ApplicationController
  def index
    @cart = session[:cart] || {}
    @subtotal = calculate_subtotal
    @taxes = calculate_taxes(@subtotal)
    @total_price = @subtotal + @taxes
    set_customer_address
  end

  def guest
    @address ||= session[:guest_address] || {}
    @provinces_list = Province.all.map { |province| [province.name, province.id] }
  end

  def save_guest_address
    if request.post?
      address_params = params.require(:address).permit(:address_line1, :city, :province, :postal_code)

      if address_params.values.any?(&:blank?)
        flash[:error] = 'Please fill in all the required fields.'
        redirect_to checkout_guest_path
      else
        session[:guest_address] = address_params
        redirect_to checkout_index_path
      end
    else
      @address ||= session[:guest_address] || {}
      @provinces_list = Province.all.map { |province| [province.name, province.id] }
    end
  end

  private

  def calculate_subtotal
    subtotal = 0
    @cart.each do |product_id, quantity|
      product = Product.find(product_id)
      subtotal += product.price * quantity
    end
    subtotal
  end

  def calculate_taxes(subtotal)
    province_id = nil

    if customer_signed_in? && current_customer.primary_province
      province_id = current_customer.primary_province.id
    elsif session[:guest_address].present?
      province_id = session[:guest_address]['province']
    end

    province = Province.find_by(id: province_id)
    return 0 unless province

    gst_amount = subtotal * province.GST
    pst_amount = subtotal * province.PST
    hst_amount = subtotal * province.HST

    gst_amount + pst_amount + hst_amount
  end

  def set_customer_address
    if customer_signed_in? && current_customer.primary_address.present?
      @customer_address = {
        address: current_customer.primary_address,
        city: current_customer.primary_city,
        postal_code: current_customer.primary_postal_code,
        province: current_customer.primary_province
      }
    elsif session[:guest_address].present?
      guest_address = session[:guest_address]
      @customer_address = {
        address: guest_address['address_line1'],
        city: guest_address['city'],
        postal_code: guest_address['postal_code'],
        province: Province.find(guest_address['province'])
      }
    else
      @customer_address = nil
    end
  end

  def create
    @cart = session[:cart] || {}
    subtotal = calculate_subtotal
    taxes = calculate_taxes(subtotal)
    total_price = subtotal + taxes

    line_items = @cart.map do |product_id, quantity|
      product = Product.find(product_id)
      {
        price_data: {
          currency: 'cad',
          product_data: { name: product.name },
          unit_amount: (product.price * 100).to_i,
        },
        quantity: quantity,
      }
    end

    taxes_item = {
      price_data: {
        currency: 'cad',
        product_data: { name: 'Calculated Taxes' },
        unit_amount: (taxes * 100).to_i,
      },
      quantity: 1
    }

    line_items << taxes_item

    customer_address = if customer_signed_in?
                         {
                           address: current_customer.primary_address,
                           city: current_customer.primary_city,
                           postal_code: current_customer.primary_postal_code,
                           province: current_customer.primary_province.id
                         }
                       elsif session[:guest_address].present?
                         guest_address = session[:guest_address]
                         {
                           address: guest_address['address_line1'],
                           city: guest_address['city'],
                           postal_code: guest_address['postal_code'],
                           province: guest_address['province']
                         }
                       end

    session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: line_items,
      mode: 'payment',
      success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: checkout_cancel_url,
      metadata: {
        customer_address: customer_address.to_json,
        cart_info: @cart.to_json
      }
    })

    redirect_to session.url, allow_other_host: true, status: 303
  end

  def success
    session_id = params[:session_id]
    stripe_session = Stripe::Checkout::Session.retrieve(session_id)

    metadata = stripe_session.metadata
    customer_address = JSON.parse(metadata['customer_address'])

    province = Province.find_by(id: customer_address['province'])
    gst_rate = province.GST.to_f
    pst_rate = province.PST.to_f
    hst_rate = province.HST.to_f

    @cart_info = JSON.parse(metadata['cart_info'])
    @subtotal = 0
    @cart_info.each do |product_id, quantity|
      product = Product.find(product_id)
      @subtotal += product.price * quantity
    end

    @gst_amount = @subtotal * gst_rate
    @pst_amount = @subtotal * pst_rate
    @hst_amount = @subtotal * hst_rate
    @total_amount = @subtotal + @gst_amount + @pst_amount + @hst_amount

    @order = Order.create!(
      order_date: Date.current,
      GST: @gst_amount,
      HST: @hst_amount,
      PST: @pst_amount,
      total_amount: @total_amount,
      status: 'paid',
      customer_id: customer_signed_in? ? current_customer.id : nil,
      payment_intent_id: stripe_session.payment_intent
    )

    @cart_info.each do |product_id, quantity|
      product = Product.find(product_id)
      OrderItem.create!(
        product_id: product.id,
        order_id: @order.id,
        quantity: quantity,
        price: product.price * quantity,
      )
    end

    session[:cart] = nil
  end

  def cancel
    # Handle cancellation logic here
  end
end
