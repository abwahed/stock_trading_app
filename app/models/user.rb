# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :businesses, foreign_key: :owner_id
  has_many :orders, foreign_key: :buyer_id

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :role, presence: true

  enum :role, { buyer: 0, owner: 1 }
end
