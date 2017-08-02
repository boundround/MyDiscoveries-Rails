class Hubspot::SendDealWorker
  include Sidekiq::Worker
  def perform(deal_id)
    deal = Spree::Order.find deal_id
    if deal
    	deal.send_to_hubspot
    end
  end
end