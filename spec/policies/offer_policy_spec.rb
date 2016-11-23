require 'rails_helper'
describe OfferPolicy do
  subject     { described_class.new(user, offer) }
  let(:offer) { Offer.create(name: Faker::Lorem.sentence) }

  context "for a admin user" do
    let(:user) { build(:user, :admin) }

    it { is_expected.to permit_action(:show)    }
    it { is_expected.to permit_action(:create)  }
    it { is_expected.to permit_action(:new)     }
    it { is_expected.to permit_action(:update)  }
    it { is_expected.to permit_action(:edit)    }
    it { is_expected.to permit_action(:destroy) }
  end

  context "for a publisher user" do
    let(:user) { build(:user, :publisher) }

    it { is_expected.to permit_action(:show)    }
    it { is_expected.to permit_action(:create)  }
    it { is_expected.to permit_action(:new)     }
    it { is_expected.to permit_action(:update)  }
    it { is_expected.to permit_action(:edit)    }
    it { is_expected.to permit_action(:destroy) }
  end

  context "for a regular user" do
    let(:user) { build(:user, :regular) }

    it { is_expected.to permit_action(:show)    }
    it { is_expected.to forbid_action(:create)  }
    it { is_expected.to forbid_action(:new)     }
    it { is_expected.to forbid_action(:update)  }
    it { is_expected.to forbid_action(:edit)    }
    it { is_expected.to forbid_action(:destroy) }
  end
end
