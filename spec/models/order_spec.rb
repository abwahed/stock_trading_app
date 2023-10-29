# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  it 'is valid with valid attributes' do
    order = build(:order, business: create(:business), buyer: create(:user))
    expect(order).to be_valid
  end

  it 'is not valid without a quantity' do
    order = build(:order, quantity: nil, business: create(:business), buyer: create(:user))
    expect(order).to_not be_valid
  end

  it 'is not valid with a negative quantity' do
    order = build(:order, quantity: -10, business: create(:business), buyer: create(:user))
    expect(order).to_not be_valid
  end

  it 'is not valid if quantity is greater than shares available' do
    order = build(:order, quantity: 100, business: create(:business, shares_available: 99), buyer: create(:user))
    expect(order).to_not be_valid
  end

  it 'is not valid without a price' do
    order = build(:order, price: nil, business: create(:business), buyer: create(:user))
    expect(order).to_not be_valid
  end

  it 'is not valid with a negative price' do
    order = build(:order, price: -40.32, business: create(:business), buyer: create(:user))
    expect(order).to_not be_valid
  end

  it 'is not valid without a status' do
    order = build(:order, status: nil, business: create(:business), buyer: create(:user))
    expect(order).to_not be_valid
  end

  it 'is not valid without buyer' do
    order = build(:order, business: create(:business), buyer: nil)
    expect(order).to_not be_valid
  end

  it 'is not valid without business' do
    order = build(:order, business: nil, buyer: create(:user))
    expect(order).to_not be_valid
  end

  it 'belongs to a buyer' do
    user = create(:user)
    order = build(:order, business: create(:business), buyer: user)
    expect(order.buyer).to eq(user)
  end

  it 'belongs to a business' do
    business = build(:business, owner: create(:user, role: 'owner'))
    order = build(:order, business:, buyer: create(:user))
    expect(order.business).to eq(business)
  end
end
