# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:buyer) { create(:user, role: 'buyer') }
  let(:buyer_authorization) { ActionController::HttpAuthentication::Basic.encode_credentials(buyer.username, buyer.password) }
  let(:owner) { create(:user, role: 'owner') }
  let(:owner_authorization) { ActionController::HttpAuthentication::Basic.encode_credentials(owner.username, owner.password) }
  let(:business) { create(:business, owner:) }
  let(:order) { create(:order, business:, buyer:) }
  let(:valid_attributes) { { business_id: business.id, order: { quantity: 10, price: 100 } } }
  let(:invalid_attributes) { { business_id: business.id, order: { quantity: 0, price: -100 } } }

  describe 'POST #create' do
    context 'when no user is authenticated' do
      it 'returns unauthorized' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a buyer role' do
      before { request.env['HTTP_AUTHORIZATION'] = buyer_authorization }

      it 'creates a new order' do
        expect do
          post :create, params: valid_attributes
        end.to change(Order, :count).by(1)
      end

      it 'returns a 201 Created response' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
      end
    end

    context 'with owner role' do
      before { request.env['HTTP_AUTHORIZATION'] = owner_authorization }

      it 'returns unauthorized' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid attributes' do
      before { request.env['HTTP_AUTHORIZATION'] = buyer_authorization }

      it 'does not create a new order' do
        expect do
          post :create, params: invalid_attributes
        end.to change(Order, :count).by(0)
      end

      it 'returns a 422 Unprocessable Entity response' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #index' do
    context 'as owner role' do
      before { request.env['HTTP_AUTHORIZATION'] = owner_authorization }

      it 'returns a success response' do
        get :index, params: { business_id: business.id }
        expect(response).to have_http_status(:success)
      end
    end

    context 'as a buyer role' do
      before { request.env['HTTP_AUTHORIZATION'] = buyer_authorization }

      it 'returns unauthorized' do
        get :index, params: { business_id: business.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when no user is authenticated' do
      it 'returns unauthorized' do
        get :index, params: { business_id: business.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH #update' do
    let(:valid_update_attributes) { { id: order.id, order: { quantity: 10, price: 100 } } }
    let(:invalid_update_attributes) { { id: order.id, order: { quantity: -10.5, price: -100 } } }

    context 'when no user is authenticated' do
      it 'returns unauthorized' do
        patch :update, params: valid_update_attributes
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'as owner role' do
      before { request.env['HTTP_AUTHORIZATION'] = owner_authorization }

      it 'returns unauthorized' do
        patch :update, params: valid_update_attributes
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'as a buyer role' do
      before { request.env['HTTP_AUTHORIZATION'] = buyer_authorization }

      it 'returns 422 Unprocessable Entity if already accepted' do
        order = create(:order, status: 'accepted', business:, buyer:)
        patch :update, params: { id: order.id, order: { quantity: 10, price: 100 } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns success response' do
        patch :update, params: valid_update_attributes
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid attributes' do
      before { request.env['HTTP_AUTHORIZATION'] = buyer_authorization }

      it 'returns a 422 Unprocessable Entity response' do
        patch :update, params: invalid_update_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #accept' do
    context 'when no user is authenticated' do
      it 'returns unauthorized' do
        patch :accept, params: { id: order.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'as owner role' do
      it 'returns unauthorized if business is not owned by this owner' do
        owner2 = create(:user, role: 'owner')
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(owner2.username, owner2.password)
        patch :accept, params: { id: order.id }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns 422 Unprocessable Entity if order already accepted' do
        order2 = create(:order, status: 'accepted', business:, buyer:)
        request.env['HTTP_AUTHORIZATION'] = owner_authorization
        patch :accept, params: { id: order2.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns success response' do
        request.env['HTTP_AUTHORIZATION'] = owner_authorization
        patch :accept, params: { id: order.id }
        expect(response).to have_http_status(:success)
      end
    end

    context 'as a buyer role' do
      before { request.env['HTTP_AUTHORIZATION'] = buyer_authorization }

      it 'returns unauthorized' do
        patch :accept, params: { id: order.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH #reject' do
    context 'when no user is authenticated' do
      it 'returns unauthorized' do
        patch :reject, params: { id: order.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'as owner role' do
      it 'returns unauthorized if business is not owned by this owner' do
        owner2 = create(:user, role: 'owner')
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(owner2.username, owner2.password)
        patch :reject, params: { id: order.id }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns 422 Unprocessable Entity if order already accepted' do
        order2 = create(:order, status: 'accepted', business:, buyer:)
        request.env['HTTP_AUTHORIZATION'] = owner_authorization
        patch :reject, params: { id: order2.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns success response' do
        request.env['HTTP_AUTHORIZATION'] = owner_authorization
        patch :reject, params: { id: order.id }
        expect(response).to have_http_status(:success)
      end
    end

    context 'as a buyer role' do
      before { request.env['HTTP_AUTHORIZATION'] = buyer_authorization }

      it 'returns unauthorized' do
        patch :reject, params: { id: order.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
