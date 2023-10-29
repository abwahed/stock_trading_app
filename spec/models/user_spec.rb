# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = build(:user, role: 'buyer')
    expect(user).to be_valid
  end

  it 'is not valid without a role' do
    user = build(:user, role: nil)
    expect(user).to_not be_valid
  end

  it 'is not valid without an username' do
    user = build(:user, username: nil)
    expect(user).to_not be_valid
  end

  it 'is not valid with a duplicate username' do
    create(:user, username: 'username')
    user = build(:user, username: 'username')
    expect(user).to_not be_valid
  end

  it 'has many businesses as a owner' do
    user = create(:user, role: 'owner')
    business1 = create(:business, owner: user)
    business2 = create(:business, owner: user)
    expect(user.businesses).to include(business1, business2)
  end

  it 'has many orders as a buyer' do
    user = create(:user, role: 'buyer')
    order1 = create(:order, buyer: user)
    order2 = create(:order, buyer: user)
    expect(user.orders).to include(order1, order2)
  end
end
