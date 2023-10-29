# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    association :buyer, factory: :user
    business
    quantity { 3 }
    price { 60.123 }
    status { 'pending' }
  end
end
