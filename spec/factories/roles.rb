FactoryGirl.define do
  factory :contributor_role, class: Role do |f|
    f.name { 'contributor' }
  end

  factory :publisher_role, class: Role do |f|
    f.name { 'publisher' }
  end

  factory :editor_role, class: Role do |f|
    f.name { 'editor' }
  end

  factory :role do |f|
    f.name { "contributor" }
  end
end
