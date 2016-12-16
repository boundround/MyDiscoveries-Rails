FactoryGirl.define do
  factory :subcategory do |f|
    f.name { Faker::Lorem.sentence }
  end
end
