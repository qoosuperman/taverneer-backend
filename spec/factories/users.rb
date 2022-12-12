# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User - #{n}" }
    sequence(:email) { |n| "email_#{n}@gmail.com" }
    password { 'password1234' }

    trait :admin do
      is_admin { true }
    end
  end
end
