require 'rails_helper'

RSpec.describe Offer, type: :model do
  describe '#shopify_product' do
    context 'new' do
      it { expect(Offer.new.shopify_product).to eq(nil) }
    end

    context 'existing' do
      let(:offer) { create(:offer) }
      let!(:shopify_product) do
        VCR.use_cassette('offers/success_create_shopify_product') do
          Offer::Shopify::CreateProduct.call(offer)
        end
      end

      it 'returns an associated shopify product' do
        VCR.use_cassette('offers/success_find_shopify_product') do
          expect(offer.shopify_product).to eq(shopify_product)
        end
      end
    end
  end
end
