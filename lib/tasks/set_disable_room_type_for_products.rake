namespace :update do
  desc "Update ax_cust_account for users and ax_sales_id for orders"
  task disable_room_type: :environment do
    Spree::Product.all.each do |product|
      room_type_present = product.variants.pluck(:room_type).any?(&:present?)
      product.update(disable_room_type: true) unless room_type_present
    end
  end
end
