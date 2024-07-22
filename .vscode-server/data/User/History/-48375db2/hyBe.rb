# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    columns do
      column do
        panel "Recent Orders" do
          ul do
            Order.order('created_at DESC').limit(5).map do |order|
              li link_to("Order ##{order.id} - #{order.created_at.strftime('%B %d, %Y')}", admin_order_path(order))
            end
          end
        end
      end

      column do
        panel "Info" do
          para "Welcome to the Prettyface E-commerce Admin Panel."
          para "Here you can manage all aspects of the store, including products, orders, and customers."
        end
      end
    end
  end # content
end