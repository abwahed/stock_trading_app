# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :business
  belongs_to :buyer, class_name: 'User'

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validate :shares_available

  enum :status, { pending: 0, accepted: 1, rejected: 2 }

  scope :pending, -> { where(status: 'pending') }
  scope :accepted, -> { where(status: 'accepted') }
  scope :rejected, -> { where(status: 'rejected') }

  private

  def shares_available
    return if !quantity.nil? && business.present? && business.shares_available >= quantity

    errors.add(:quantity, 'Shares available is less than order quantity')
  end
end
