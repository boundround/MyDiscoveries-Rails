FactoryGirl.define do
  factory :place do |f|
    f.display_name { Faker::Lorem.sentence }
  end
end
