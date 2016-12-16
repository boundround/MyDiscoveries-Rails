shared_examples 'a controller for admins' do |http_method, action|
  let(:params) { {} }
  let(:perform_action) { send(http_method, action, params) }

  context 'not signed in user' do
    it 'redirects to root' do
      expect(perform_action).to redirect_to(root_path)
    end
  end

  context 'signed in user' do
    before { sign_in user }

    [:admin, :publisher].each do |role|
      context "is #{role.to_s.camelize}" do
        let(:user) { create(:user, role) }

        it "doesn't raise 404" do
          expect { perform_action }.not_to raise_error
        end

        it 'has not a 403 status code' do
          perform_action
          expect(response.status).not_to eq(403)
        end
      end
    end

    [:editor, :contributor].each do |role|
      context "is #{role.to_s.camelize}" do
        let(:user) { create(:user, role) }

        it 'redirects to root' do
          expect(perform_action).to redirect_to(root_path)
        end
      end
    end
  end
end
