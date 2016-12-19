FactoryGirl.define do
  factory :order do
    title { Faker::Lorem.sentence }
    offer
    user
  end
end
