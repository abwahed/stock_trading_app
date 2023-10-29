# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BusinessesController, type: :controller do
  let(:owner) { create(:user, role: 'owner') }
  let(:owner_authorization) { ActionController::HttpAuthentication::Basic.encode_credentials(owner.username, owner.password) }
  let(:valid_attributes) { { name: 'Sample Business', shares_available: 100 } }
  let(:invalid_attributes) { { name: nil, shares_available: -10 } }
  let(:buyer) { create(:user) }
  let(:buyer_authorization) { ActionController::HttpAuthentication::Basic.encode_credentials(buyer.username, buyer.password) }

  describe 'POST #create' do
    context 'when no user is authenticated' do
      it 'returns unauthorized' do
        post :create, params: { business: valid_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with buyer role' do
      before { request.env['HTTP_AUTHORIZATION'] = buyer_authorization }

      it 'does not create a new business' do
        expect do
          post :create, params: { business: valid_attributes }
        end.to change(Business, :count).by(0)
      end

      it 'returns a 401 Unauthorized response' do
        post :create, params: { business: valid_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid attributes' do
      before { request.env['HTTP_AUTHORIZATION'] = owner_authorization }

      it 'creates a new business' do
        expect do
          post :create, params: { business: valid_attributes }
        end.to change(Business, :count).by(1)
      end

      it 'returns a 201 Created response' do
        post :create, params: { business: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      before { request.env['HTTP_AUTHORIZATION'] = owner_authorization }

      it 'does not create a new business' do
        expect do
          post :create, params: { business: invalid_attributes }
        end.to change(Business, :count).by(0)
      end

      it 'returns a 422 Unprocessable Entity response' do
        post :create, params: { business: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #index' do
    context 'when no user is authenticated' do
      it 'returns unauthorized' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with owner role' do
      it 'returns a 401 Unauthorized response' do
        request.env['HTTP_AUTHORIZATION'] = owner_authorization
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with buyer role' do
      it 'returns a success response' do
        request.env['HTTP_AUTHORIZATION'] = buyer_authorization
        get :index
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #order_history' do
    let(:business) { create(:business, owner:) }

    context 'when no user is authenticated' do
      it 'returns unauthorized' do
        get :index, params: { id: business.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with owner role' do
      it 'returns a 401 Unauthorized response' do
        request.env['HTTP_AUTHORIZATION'] = owner_authorization
        get :index, params: { id: business.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with buyer role' do
      it 'returns a success response' do
        request.env['HTTP_AUTHORIZATION'] = buyer_authorization
        get :index, params: { id: business.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
