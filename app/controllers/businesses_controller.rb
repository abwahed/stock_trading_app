# frozen_string_literal: true

class BusinessesController < ApplicationController
  before_action :authenticate_owner, only: [:create]
  before_action :authenticate_buyer, only: %i[index order_history]
  before_action :set_business, only: [:order_history]

  # POST /businesses
  def create
    @business = @current_user.businesses.new(business_params)

    if @business.save
      render json: @business, status: :created
    else
      render json: @business.errors, status: :unprocessable_entity
    end
  end

  # GET /businesses
  def index
    @businesses = Business.available
    render json: @businesses
  end

  def order_history
    @accepted_orders = @business.orders.accepted
    render json: @accepted_orders
  end

  # GET /businesses/1
  # def show
  #   render json: @business
  # end

  private

  def business_params
    params.require(:business).permit(:name, :shares_available)
  end

  def authenticate_owner
    return if @current_user.owner?

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def authenticate_buyer
    return if @current_user.buyer?

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def set_business
    @business = Business.find(params[:id])
  end
end
