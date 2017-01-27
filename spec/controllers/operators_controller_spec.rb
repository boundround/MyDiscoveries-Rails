require 'rails_helper'

RSpec.describe OperatorsController, type: :controller do
  it_behaves_like "a controller for admins", :get, :index
  it_behaves_like "a controller for admins", :get, :new
  it_behaves_like "a controller for admins", :get, :edit do
    let(:params) { { id: create(:operator).id } }
  end

  it_behaves_like "a controller for admins", :delete, :destroy do
    let(:params) { { id: create(:operator).id } }
  end

  it_behaves_like "a controller for admins", :post, :create do
    let(:params) { { operator: { name: Faker::Lorem.sentence } } }
  end

  it_behaves_like "a controller for admins", :put, :update do
    let(:params) do
      {
        id: create(:operator).id,
        operator: { name: Faker::Lorem.sentence }
      }
    end
  end

  describe 'POST #create' do

    before do
      @admin = create(:user, :admin)
      sign_in @admin
    end

    context 'current user create operator' do
      let(:params) do
        {
          operator: {
            name: Faker::Lorem.sentence,
            tags: ["tag1", "tag2", ""]
          }
        }
      end

      it 'creates operator' do
        expect{post(:create, params)}.to change{Operator.count}.from(0).to(1)
        created_operator = Operator.last
        expect(created_operator.name).to eql(params[:operator][:name])
      end

      it 'rejects blank tags' do
        post(:create, params)
        created_operator = Operator.last
        expect(created_operator.tags).to_not eql(params[:operator][:tags])
        expect(created_operator.tags).to eql(params[:operator][:tags].select!(&:present?))
      end

      it 'shows right flash message' do
        post(:create, params)
        expect(flash[:notice]).to eql('Operator succesfully saved')
      end
    end

    context 'current user do not create operator' do
      let(:params) { { operator: { tags: ["tag1", "tag2", ""] } } }

      it 'does not create operator' do
        expect{post(:create, params)}.to_not change(Operator, :count)
      end

      it 'shows right flash message' do
        post(:create, params)
        expect(flash[:alert]).to eql('Operator not saved!')
      end
    end
  end
  #
  describe 'PATCH #update' do

    before do
      @admin    = create(:user, :admin)
      @operator = create(:operator)
      sign_in @admin
    end

    context 'current user update operator' do
      let(:params) do
        {
          id: @operator.id,
          operator: { name: Faker::Lorem.sentence, tags: ["tag1", "tag2", ""] }
        }
      end

      it 'updates operator' do
        operator_name = @operator.name
        expect{patch(:update, params)}.to change{@operator.reload.name}.from(operator_name).to(params[:operator][:name])
      end

      it 'rejects blank tags' do
        patch(:update, params)
        expect(@operator.reload.tags).to_not eql(params[:operator][:tags])
        expect(@operator.reload.tags).to eql(params[:operator][:tags].select!(&:present?))
      end

      it 'shows right flash message' do
        patch(:update, params)
        expect(flash[:notice]).to eql('Operator Updated')
      end
    end

    context 'current user do not update operator' do
      let(:params) do
        {
          id: @operator.id,
          operator: { name: '' }
        }
      end

      it 'shows right flash message' do
        patch(:update, params)
        expect(flash[:alert]).to eql('Sorry, there was an error updating this Operator')
      end
    end
  end
end
