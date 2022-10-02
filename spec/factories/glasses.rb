# frozen_string_literal: true

FactoryBot.define do
  factory :glass do
    sequence(:name) { |n| "Glass - #{n}" }
  end
end
