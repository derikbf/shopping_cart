# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Test Product #{n}" }
    price { 19.99 }
  end
end
