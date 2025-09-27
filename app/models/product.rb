# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :cart_items # um produto pode estar em vários itens de carrinho
  has_many :carts, through: :cart_items # um produto pode estar em vários carrinhos

  validates_presence_of :name, :price
  validates_numericality_of :price, greater_than_or_equal_to: 0
end
