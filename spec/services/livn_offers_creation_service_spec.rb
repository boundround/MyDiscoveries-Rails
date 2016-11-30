require 'rails_helper'

RSpec.describe LivnOffersCreationService do

  describe '#retrieve_product' do

    context 'retrieves product', vcr: { cassette_name: "offers/success_fetch_product_id" } do
      let(:service) { LivnOffersCreationService.new(997) }

      it 'has product in http response' do
        service.retrieve_product
        expect(service.response.http_response.parsed_response.try(:[], 'product')).to_not eql(nil)
      end
    end

    context 'does not retrieve product', vcr: { cassette_name: "offers/fail_fetch_product_id" } do
      let(:service)  { LivnOffersCreationService.new(1) }

      it 'has not product in http response' do
        service.retrieve_product
        expect(service.response.http_response.parsed_response.try(:[], 'product')).to eql(nil)
      end
    end
  end

  describe '#call' do

    context 'retrieves and creates offer', vcr: { cassette_name: "offers/success_fetch_product_id" } do
      let(:service) { LivnOffersCreationService.new(997) }

      before { service.call }

      it 'creates valid offer' do
        expect(service.response.offer.valid?).to eql(true)
        expect(service.response.offer.persisted?).to eql(true)
        expect(Offer.count).to_not eql(0)
      end

      it 'has not errors' do
        expect(service.response.errors.count).to eql(0)
      end
    end

    context 'does not retrieve and create offer', vcr: { cassette_name: "offers/fail_fetch_product_id" } do
      let(:service)  { LivnOffersCreationService.new(1) }

      before { service.call }

      it 'does not create valid offer' do
        expect(service.response.offer).to eql(nil)
        expect(Offer.count).to eql(0)
      end

      it 'has errors' do
        expect(service.response.errors.count).to_not eql(0)
      end
    end
  end

end
