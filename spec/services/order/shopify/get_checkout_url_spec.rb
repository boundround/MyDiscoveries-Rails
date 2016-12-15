require 'rails_helper'

RSpec.describe Order::Shopify::GetCheckoutUrl do
  subject { described_class.call(order) }
  let(:order) { create(:order, number_of_adults: 2, number_of_children: 3) }
  let(:checkout_url) do
    'https://bound-round.myshopify.com/cart/28592062217:2,28592062281:3'
  end
  before do
    VCR.use_cassette('offers/success_create_shopify_product') do
      Offer::Shopify::CreateProduct.call(order.offer)
    end
  end

  describe '#call', vcr: {
    cassette_name: 'offers/success_find_shopify_product',
    allow_playback_repeats: true
  } do
    it { expect(subject).to eq(checkout_url) }
  end
end
