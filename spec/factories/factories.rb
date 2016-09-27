require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.name      { Faker::Name.name }
    f.email     { Faker::Internet.email }
    f.username  { Faker::Name.name }
    f.password  { "password" }
    f.admin     { User.first.blank? ? true : false }
  end

end