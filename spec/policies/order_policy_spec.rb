require 'rails_helper'
describe OrderPolicy do
  subject     { described_class.new(user, order) }
  let(:order) { Order.create(title: Faker::Lorem.sentence) }

  context "for a regular user" do
    let(:user) { build(:user, :regular) }

    it { is_expected.to permit_action(:create)   }
    it { is_expected.to permit_action(:new)      }
    it { is_expected.to permit_action(:update)   }
    it { is_expected.to permit_action(:edit)     }
    it { is_expected.to permit_action(:checkout) }
  end
end
