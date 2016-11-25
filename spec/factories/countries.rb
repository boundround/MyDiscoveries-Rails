FactoryGirl.define do
  factory :country do |f|
    f.display_name { Faker::Lorem.sentence }
  end
end
