namespace :spree_orders do
  desc "Mark all orders with SNA products as :sent_to_sna"
  task :sna_mark_sent => :environment do
    Spree::Order.all.each do |order|
    	if order.products.where(operator_id: 1).any? && order.authorized? && !order.sent_to_sna?
    		order.update(sent_to_sna: true)
    	end
    end
  end
end