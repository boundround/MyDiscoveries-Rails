FactoryGirl.define do
  factory :user do |f|
    f.name      { Faker::Name.name }
    f.email     { Faker::Internet.email }
    f.username  { Faker::Name.name }
    f.password  { "password" }

    trait :admin do
      admin { true }
    end

    trait :contributor do
      admin { false }
      after(:build) do |user|
        user.roles << create(:contributor_role)
        user.save
      end
    end

    trait :publisher do
      admin { false }
      after(:build) do |user|
        user.roles << create(:publisher_role)
        user.save
      end
    end

    trait :editor do
      admin { false }
      after(:build) do |user|
        user.roles << build(:editor_role)
        user.save
      end
    end

    trait :regular do
      admin { false }
    end
  end
end
