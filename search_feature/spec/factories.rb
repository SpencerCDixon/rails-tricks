FactoryGirl.define do
  factory :movie do
    sequence(:title) { |n| "Troll #{n}" }
    year 1999
    synopsis "Total garbage."
    rating 50
  end

  factory :actor do
    sequence(:name) { |n| "Tom Cruise #{n}" }
  end

  factory :cast_members do
    movie
    actor
  end
end
