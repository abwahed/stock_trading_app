# frozen_string_literal: true

FactoryBot.define do
  factory :business do
    association :owner, factory: :user
    sequence(:name) { |n| "business-#{n}" }
    shares_available { 40 }
  end
end
