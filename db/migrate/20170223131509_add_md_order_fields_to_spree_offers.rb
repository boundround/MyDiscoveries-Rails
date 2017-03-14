class AddMdOrderFieldsToSpreeOffers < ActiveRecord::Migration
  def change
    change_table "spree_orders" do |t|
      t.integer  "product_id"
      t.string   "title"
      t.integer  "number_of_children",   default: 0
      t.integer  "number_of_adults",     default: 0
      t.integer  "number_of_infants",    default: 0
      t.integer  "total_price",          default: 0
      t.date     "start_date"
      t.boolean  "authorized",           default: false
      t.boolean  "request_installments", default: false
      t.json     "px_response",          default: {}
      t.integer  "customer_id"
      t.boolean  "voucher_sent",         default: false
      t.string   "ax_sales_id"
      t.boolean  "created_from_ax",      default: false
    end

    add_index "spree_orders", "product_id"
    add_index "spree_orders", "customer_id"
  end
end
