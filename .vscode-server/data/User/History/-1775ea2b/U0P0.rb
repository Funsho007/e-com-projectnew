ActiveAdmin.register Order do
  permit_params :user_id, :order_date, :gst, :pst, :hst, :total_amount, :status, order_items_attributes: [:id, :product_id, :quantity, :price, :_destroy]

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :order_date
      f.input :GST
      f.input :HST
      f.input :PST
      f.input :total_amount
      f.input :status, as: :select, collection: ['new', 'paid', 'shipped']
      f.input :customer_id
      f.input :payment_intent_id
    end
    f.actions
  end








end
