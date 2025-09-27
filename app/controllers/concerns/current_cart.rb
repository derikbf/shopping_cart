# frozen_string_literal: true

module CurrentCart
  extend ActiveSupport::Concern

  private

  def set_cart
    @cart = Cart.find_by(id: session[:cart_id])

    if @cart.nil?
      @cart = Cart.create!(total_price: 0, last_interaction_at: Time.current)
      session[:cart_id] = @cart.id
    end
  end
end