namespace :update do
  desc "Update ax_cust_account for users and ax_sales_id for orders"
  task disable_room_type: :environment do
    Spree::Product.all.each do |product|
      room_type_present = product.variants.pluck(:room_type).any?(&:present?)
      product.update(disable_room_type: true) unless room_type_present
    end
  end

  task disable_all_new_options: :environment do
    Spree::Product.all.each do |product|
      product.disable_departure_date = true
      product.disable_departure_city = true
      product.disable_package_option = true
      product.disable_accommodation = true
      product.save
    end
  end
end
