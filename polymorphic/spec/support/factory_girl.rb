require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
  end

  factory :post do
    title 'Polymorphic Associations are so cool!'
    description 'This repo is to be used to teach polymorphic associations'
  end
end
