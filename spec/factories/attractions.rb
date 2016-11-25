FactoryGirl.define do
  factory :attraction do |f|
    f.display_name { Faker::Lorem.sentence }
  end
end
