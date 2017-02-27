namespace :ax_fields do
  desc "Update ax_cust_account for users and ax_sales_id for orders"
  task update: :environment do
    User.all.each{ |u| u.set_ax_cust_account! }
    Order.all.each{ |o| o.set_ax_sales_id! }
  end
end
