# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Business, type: :model do
  it 'is valid with valid attributes' do
    business = build(:business, owner: create(:user, role: 'owner'))
    expect(business).to be_valid
  end

  it 'is not valid without a name' do
    business = build(:business, name: nil, owner: create(:user, role: 'owner'))
    expect(business).to_not be_valid
  end

  it 'is not valid without shares_available' do
    business = build(:business, shares_available: nil, owner: create(:user, role: 'owner'))
    expect(business).to_not be_valid
  end

  it 'is not valid with negative shares_available' do
    business = build(:business, shares_available: -10, owner: create(:user, role: 'owner'))
    expect(business).to_not be_valid
  end

  it 'is not valid without owner' do
    business = build(:business, owner: nil)
    expect(business).to_not be_valid
  end

  it 'has many orders' do
    business = create(:business, owner: create(:user, role: 'owner'))
    order1 = create(:order, business:)
    order2 = create(:order, business:)
    expect(business.orders).to include(order1, order2)
  end

  it 'belongs to an owner' do
    user = create(:user, role: 'owner')
    business = create(:business, owner: user)
    expect(business.owner).to eq(user)
  end
end
