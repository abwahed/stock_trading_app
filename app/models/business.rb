# frozen_string_literal: true

class Business < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :orders

  validates :name, presence: true
  validates :shares_available, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :available, -> { where("shares_available > 0") }
end
