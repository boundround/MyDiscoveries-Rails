FactoryGirl.define do
  factory :offer do |f|
    f.name { Faker::Lorem.sentence }
    f.startDate { Date.current - 1.day }
    f.endDate   { Date.current }
  end
end
