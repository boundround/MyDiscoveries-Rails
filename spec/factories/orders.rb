FactoryGirl.define do
  factory :order do |f|
    f.title { Faker::Lorem.sentence }
    f.offer factory: :offer
    f.user factory: :regular
  end
end
