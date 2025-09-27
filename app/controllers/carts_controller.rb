# frozen_string_literal: true

class CartsController < ApplicationController
  ## TODO Escreva a lógica dos carrinhos aqui

  include CurrentCart
  before_action :set_cart

  def add_product
    puts "entrou no cart controller add_prod"
    product = Product.find(params[:product_id])

    cart_item = @cart.cart_items.find_or_initialize_by(product: product)
    cart_item.quantity = (cart_item.quantity || 0) + params[:quantity].to_i
    cart_item.save!

    render json: CartPresenter.new(@cart).as_json, status: :created
  end
end
