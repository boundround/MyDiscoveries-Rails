FactoryGirl.define do
  factory :offer do |f|
    f.name { Faker::Commerce.product_name }
    f.startDate { Date.current - 1.day }
    f.endDate   { Date.current }

    after(:build) do |offer|
      offer.operator = create(:operator)
      offer.save
    end
  end
end
