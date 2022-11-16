# frozen_string_literal: true

FactoryBot.define do
  factory :recipe do
    glass
    cocktail

    trait :published do
      after :create, &:publish!
    end
  end
end
