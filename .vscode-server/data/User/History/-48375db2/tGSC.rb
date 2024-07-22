ActiveAdmin.register_page "Dashboard" do
  content do
    div class: "dashboard_banner" do
      h2 "Admin Dashboard"

      div class: "banner_links" do
        span class: "banner_link" do
          link_to "Brands", admin_brands_path
        end
        span class: "banner_link" do
          link_to "Categories", admin_categories_path
        end
        span class: "banner_link" do
          link_to "Customers", admin_customers_path
        end
        span class: "banner_link" do
          link_to "Orders", admin_orders_path
        end
        span class: "banner_link" do
          link_to "Order Items", admin_order_items_path
        end
        span class: "banner_link" do
          link_to "Pages", admin_pages_path
        end
        span class: "banner_link" do
          link_to "Products", admin_products_path
        end
        span class: "banner_link" do
          link_to "Provinces", admin_provinces_path
        end
        span class: "banner_link" do
          link_to "Tags", admin_tags_path
        end
        span class: "banner_link" do
          link_to "Types", admin_types_path
        end
      end
    end

    columns do
      column do
        panel "Recent Brands" do
          ul do
            Brand.order(created_at: :desc).limit(5).map do |brand|
              li link_to(brand.name, admin_brand_path(brand))
            end
          end
        end
      end

      column do
        panel "Recent Categories" do
          ul do
            Category.order(created_at: :desc).limit(5).map do |category|
              li link_to(category.name, admin_category_path(category))
            end
          end
        end
      end

      column do
        panel "Recent Products" do
          ul do
            Product.order(created_at: :desc).limit(5).map do |product|
              li link_to(product.name, admin_product_path(product))
            end
          end
        end
      end
    end
  end
end
