require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe 'POST #create' do

    before do
      @offer = create(:offer)
      @user  = create(:user, :regular)
      sign_in @user
    end

    context 'with valid params' do
      let(:params) do
        {
          order: {
            title: Faker::Lorem.sentence
          },
          offer_id: @offer.id
        }
      end
      let(:checkout_url) { 'https://www.shopify.com/' }
      before do
        allow(Order::Shopify::GetCheckoutUrl).to receive(:call) { checkout_url }
      end

      it 'creates an order' do
        expect{post(:create, params)}.to change{Spree::Order.count}.from(0).to(1)
        created_order = Spree::Order.last
        expect(created_order.title).to eql(params[:order][:title])
      end

      it 'redirects to the order checkout url' do
        post(:create, params)
        expect(response).to redirect_to(checkout_url)
      end
    end

    context 'with invalid params' do
      let(:params) do
         {
           order: { title: '' },
           offer_id: @offer.id
         }
       end

      it 'does not create an order' do
        expect{post(:create, params)}.to_not change(Order, :count)
      end

      it 'shows a flash message' do
        post(:create, params)
        expect(flash[:alert].present?).to eql(true)
      end
    end
  end
end
