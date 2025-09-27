# frozen_string_literal: true

class CartsController < ApplicationController
  ## TODO Escreva a lógica dos carrinhos aqui

  include CurrentCart
  before_action :set_cart

  def add_product
    product = Product.find(params[:product_id])
    
    cart_item = @cart.cart_items.find_or_initialize_by(product_id: product.id)
    cart_item.quantity = (cart_item.quantity || 0) + params[:quantity].to_i
    cart_item.save!

    render json: {
      id: @cart.id,
      products: [{ id: product.id, quantity: cart_item.quantity }]
    }, status: :created
  end
end
