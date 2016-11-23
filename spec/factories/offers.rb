FactoryGirl.define do
  factory :offer do |f|
    f.name { Faker::Lorem.sentence }
  end
end
