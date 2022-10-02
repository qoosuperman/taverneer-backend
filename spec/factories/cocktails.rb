# frozen_string_literal: true

FactoryBot.define do
  factory :cocktail do
    sequence(:name) { |n| "Cocktail - #{n}" }
  end
end
