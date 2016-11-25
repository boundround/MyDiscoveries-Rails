require 'rails_helper'
RSpec.describe OffersController, type: :controller do
  it_behaves_like "a controller for admins", :get, :index

  it_behaves_like "a controller for admins", :get, :new

  it_behaves_like "a controller for admins", :get, :edit do
    let(:params) { { id: create(:offer).id } }
  end

  it_behaves_like "a controller for admins", :delete, :destroy do
    let(:params) { { id: create(:offer).id } }
  end

  it_behaves_like "a controller for admins", :post, :create do
    let(:params) { { offer: { name: Faker::Lorem.sentence } } }
  end

  it_behaves_like "a controller for admins", :put, :update do
    let(:params) do
      {
        id: create(:offer).id,
        offer: {
          name: Faker::Lorem.sentence,
          country_ids:     [ create(:country).id ],
          attraction_ids:  [ create(:attraction).id ],
          place_ids:       [ create(:place).id ],
          subcategory_ids: [ create(:subcategory).id ]
        }
      }
    end
  end

  describe 'POST #create' do

    before do
      @admin = create(:user, :admin)
      sign_in @admin
    end

    context 'current user create offer' do
      let(:params) { { offer: { name: Faker::Lorem.sentence, tags: ["tag1", "tag2", ""] } } }

      it 'creates offer' do
        expect{post(:create, params)}.to change{Offer.count}.from(0).to(1)
        created_offer = Offer.last
        expect(created_offer.name).to eql(params[:offer][:name])
      end

      it 'rejects blank tags' do
        post(:create, params)
        created_offer = Offer.last
        expect(created_offer.tags).to_not eql(params[:offer][:tags])
        expect(created_offer.tags).to eql(params[:offer][:tags].select!(&:present?))
      end

      it 'shows right flash message' do
        post(:create, params)
        expect(flash[:notice]).to eql('Offer succesfully saved')
      end
    end

    context 'current user do not create offer' do
      let(:params) { { offer: { tags: ["tag1", "tag2", ""] } } }

      it 'does not create offer' do
        expect{post(:create, params)}.to_not change(Offer, :count)
      end

      it 'shows right flash message' do
        post(:create, params)
        expect(flash[:alert]).to eql('Offer not saved!')
      end
    end
  end

  describe 'PATCH #update' do

    before do
      @admin = create(:user, :admin)
      @offer = create(:offer)
      sign_in @admin
    end

    context 'current user update offer' do
      let(:params) do
        {
          id: @offer.id,
          offer: { name: Faker::Lorem.sentence, tags: ["tag1", "tag2", ""] }
        }
      end

      it 'updates offer' do
        offer_name = @offer.name
        expect{patch(:update, params)}.to change{@offer.reload.name}.from(offer_name).to(params[:offer][:name])
      end

      it 'rejects blank tags' do
        patch(:update, params)
        expect(@offer.reload.tags).to_not eql(params[:offer][:tags])
        expect(@offer.reload.tags).to eql(params[:offer][:tags].select!(&:present?))
      end

      it 'shows right flash message' do
        patch(:update, params)
        expect(flash[:notice]).to eql('Offer Updated')
      end
    end

    context 'current user do not update offer' do
      let(:params) do
        {
          id: @offer.id,
          offer: { name: '' }
        }
      end

      it 'shows right flash message' do
        patch(:update, params)
        expect(flash[:alert]).to eql('Sorry, there was an error updating this Offer')
      end
    end
  end

end
