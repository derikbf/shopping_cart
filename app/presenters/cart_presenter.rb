# frozen_string_literal: true

class CartPresenter
  def initialize(cart)
    # Quando fazemos CartPresenter.new(@cart), o objeto do modelo Cart
    # que veio do controller é atribuído à variável de instância @cart
    # desta classe.
    @cart = cart
  end

  def as_json
    @cart.update!(total_price: calculate_total)

    {
      id: @cart.id,
      products: format_products,
      total_price: @cart.total_price.to_f
    }
  end

  private

  def calculate_total
    @cart.cart_items.joins(:product).sum('products.price * cart_items.quantity')
  end

  def format_products
    @cart.cart_items.includes(:product).map do |item|    
      {
        id: item.product.id,
        name: item.product.name,
        quantity: item.quantity,
        unit_price: item.product.price.to_f,
        total_price: (item.product.price * item.quantity).to_f
      }
    end
  end
end