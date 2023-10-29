# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Workflow', type: :request do
  let(:owner) { create(:user, role: 'owner') }
  let(:owner_authorization) { ActionController::HttpAuthentication::Basic.encode_credentials(owner.username, owner.password) }
  let(:buyer) { create(:user, role: 'buyer') }
  let(:buyer_authorization) { ActionController::HttpAuthentication::Basic.encode_credentials(buyer.username, buyer.password) }
  let!(:business) { create(:business, owner:) }

  it 'owner creates a business' do
    business_params = { business: { name: 'My Business', shares_available: 100 } }
    headers = { 'HTTP_AUTHORIZATION' => owner_authorization }
    post('/businesses', params: business_params, headers:)
    expect(response).to have_http_status(:created)
    expect(response.content_type).to eq('application/json; charset=utf-8')
    expect(Business.last.name).to eq('My Business')
  end

  it 'buyer sees a list of available businesses' do
    headers = { 'HTTP_AUTHORIZATION' => buyer_authorization }
    get('/businesses', headers:)
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(business.name)
  end

  it 'buyer creates an order' do
    order_params = { order: { business_id: business.id, quantity: 10, price: 50.0 } }
    headers = { 'HTTP_AUTHORIZATION' => buyer_authorization }
    post(business_orders_path(business_id: business.id), params: order_params, headers:)
    expect(response).to have_http_status(:created)
    last_order = Order.last
    expect(last_order.quantity).to eq(10)
    expect(last_order.price).to eq(50.0)
    expect(last_order.pending?).to be(true)
  end

  it 'owner sees a list of orders' do
    order = create(:order, business:, buyer:)
    headers = { 'HTTP_AUTHORIZATION' => owner_authorization }
    get(business_orders_path(business_id: business.id), headers:)
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(order.quantity.to_s)
  end

  it 'owner accepts an order' do
    order = create(:order, business:, buyer:)
    headers = { 'HTTP_AUTHORIZATION' => owner_authorization }
    patch(accept_order_path(order.id), headers:)
    expect(response).to have_http_status(:ok)
    expect(Order.find(order.id).accepted?).to be(true)
  end

  it 'owner rejects an order' do
    order = create(:order, business:, buyer:)
    headers = { 'HTTP_AUTHORIZATION' => owner_authorization }
    patch(reject_order_path(order.id), headers:)
    expect(response).to have_http_status(:ok)
    expect(Order.find(order.id).rejected?).to be(true)
  end
end
