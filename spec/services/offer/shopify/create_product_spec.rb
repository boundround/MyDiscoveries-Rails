require 'rails_helper'

RSpec.describe Offer::Shopify::CreateProduct do
  subject { described_class.call(offer) }
  let(:offer) do
    create(:offer, name: title,
                   highlightsStr: body_html,
                   tags: tags,
                   maxRateAdult: price,
                   maxRateChild: nil,
                   maxRateInfant: 0)
  end
  let(:title) { 'Bali & Lombok Adventure' }
  let(:body_html) { 'Dolore illum animi et neque accusantium.' }
  let(:tags) { ['a', 'b', 'c'] }
  let(:price) { 50 }
  let(:shopify_price) { '50.00' }

  describe '#call', vcr: { cassette_name: "offers/success_create_shopify_product" } do
    context 'success' do
      let(:product) { subject }

      it 'creates a shopify product' do
        expect(product.id).to be_present
      end

      it 'assigns appropriate values to a shopify product' do
        expect(product.title).to eq(title)
        expect(product.body_html).to eq(body_html)
        expect(product.vendor).to eq('Bound Round')
        expect(product.product_type).to eq('Tour')
        expect(product.tags).to eq(tags.join(', '))
        # expect(product.images)
      end

      it 'creates appropriate variants' do
        expect(product.variants.size).to eq(3)
        variant1, variant2, variant3 = product.variants
        expect(variant1.price).to eq(shopify_price)
        expect(variant1.requires_shipping).to eq(false)
        expect(variant1.title).to eq('Adult')
        expect(variant1.option1).to eq('Adult')
        expect(variant2.price).to eq(shopify_price)
        expect(variant2.requires_shipping).to eq(false)
        expect(variant2.title).to eq('Child')
        expect(variant2.option1).to eq('Child')
        expect(variant3.price).to eq('0.00')
        expect(variant3.requires_shipping).to eq(false)
        expect(variant3.title).to eq('Infant')
        expect(variant3.option1).to eq('Infant')
      end

      it 'updates an offer with shopify_product_id' do
        expect(offer.reload.shopify_product_id).to eq(nil)
        subject
        expect(offer.reload.shopify_product_id).to eq(product.id.to_s)
      end
    end
  end
end
