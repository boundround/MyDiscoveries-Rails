require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  describe 'POST #create' do

    before do
      @offer = create(:offer)
      @user  = create(:user, :regular)
      sign_in @user
    end

    context 'current user create order' do
      let(:params) do
        {
          order: {
            title: Faker::Lorem.sentence
          },
          offer_id: @offer.id
        }
      end

      it 'creates order' do
        expect{post(:create, params)}.to change{Order.count}.from(0).to(1)
        created_order = Order.last
        expect(created_order.title).to eql(params[:order][:title])
      end

      it 'shows right flash message' do
        post(:create, params)
        expect(flash[:notice].present?).to eql(true)
      end
    end

    context 'current user do not create order' do
      let(:params) do
         {
           order: { title: '' },
           offer_id: @offer.id
         }
       end

      it 'does not create order' do
        expect{post(:create, params)}.to_not change(Order, :count)
      end

      it 'shows right flash message' do
        post(:create, params)
        expect(flash[:alert].present?).to eql(true)
      end
    end
  end
end
