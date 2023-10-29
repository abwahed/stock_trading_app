# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_buyer, only: %i[create update]
  before_action :authenticate_owner, only: %i[index accept reject]
  before_action :set_business, except: %i[update accept reject]
  before_action :set_order, only: %i[update accept reject]

  # POST /businesses/:business_id/orders
  def create
    @order = @current_user.orders.new(order_params.merge(business: @business))

    if @order.save
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # GET /businesses/:business_id/orders
  def index
    @orders = @business.orders.includes(:buyer)
    render json: @orders.map do |order|
      {
        id: order.id,
        quantity: order.quantity,
        price: order.price,
        status: order.status,
        buyer_username: order.buyer.username
      }
    end
  end

  # PATCH /orders/:id
  def update
    if @order.accepted?
      render json: { error: 'Order has already been accepted.' }, status: :unprocessable_entity
    elsif @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH /orders/:id/accept
  def accept
    if @order.business.owner != @current_user
      render json: { error: 'Unauthorized to accept this order.' }, status: :unauthorized
    elsif @order.accepted?
      render json: { error: 'Order has already been accepted.' }, status: :unprocessable_entity
    else
      @order.update(status: 'accepted')
      render json: @order
    end
  end

  # PATCH /orders/:id/reject
  def reject
    if @order.business.owner != @current_user
      render json: { error: 'Unauthorized to reject this order.' }, status: :unauthorized
    elsif @order.accepted?
      render json: { error: 'Accepted orders cannot be rejected.' }, status: :unprocessable_entity
    else
      @order.update(status: 'rejected')
      render json: @order
    end
  end

  private

  def order_params
    params.require(:order).permit(:quantity, :price)
  end

  def authenticate_buyer
    return if @current_user.buyer?

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def authenticate_owner
    return if @current_user.owner?

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def set_business
    @business = Business.find(params[:business_id])
  end

  def set_order
    @order = Order.find(params[:id])
  end
end
