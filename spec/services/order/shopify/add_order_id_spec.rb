require 'rails_helper'

RSpec.describe Order::Shopify::AddOrderId do
  let(:order) { create(:order) }

  describe '#call' do
    context 'success' do

      before do
        VCR.use_cassette("orders/success_add_shopify_order_id") do
          Order::Shopify::AddOrderId.call(
            {
              'id' => 4386906377,
              'financial_status' => "paid",
              'landing_site' => "\/cart\/28612521801:1?email=test@gmail.com\u0026boundround_order_id=#{order.id}"
            }
          )
        end
      end

      it 'sets shopify_order_id' do
        expect(order.reload.shopify_order_id).to eql('4386906377')
      end

      it 'sets paid status' do
        expect(order.reload.status).to eql('paid')
      end
    end
  end
end
