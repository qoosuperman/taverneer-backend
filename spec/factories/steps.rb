# frozen_string_literal: true

FactoryBot.define do
  factory :step do
    recipe
    sequence(:position)
    sequence(:description) { |n| "Step - #{n}" }
  end
end
