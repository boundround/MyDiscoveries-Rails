class SNA::RequestProcessor
  include Sidekiq::Worker
  sidekiq_options retry: 3

  sidekiq_retries_exhausted do |msg|
    order_id = msg['args'].first
    SnaRequestFailed.delay.notification(order_id)
  end

  def perform(order_id)
    order = Spree::Order.find_by(id: order_id)
    if order
      result = SNA::Send.call(order)
      if result.response.code != '200'
        raise "SNA response: #{result.response.message}"
      else
        order.update(sent_to_sna: true)
      end
    end
  end
end
