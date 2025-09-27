# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/carts", type: :request do
  # Nosso novo teste para a Etapa 1, já usando factory
  describe "POST /cart (add_product)" do
    let!(:product) { create(:product, price: 10.0) }

    context "when adding a new product" do
      it "creates a cart and adds the product with full details" do
        post '/cart', params: { product_id: product.id, quantity: 2 }, as: :json

        expect(response).to have_http_status(:created )
        
        json_response = JSON.parse(response.body)
        
        expect(json_response['id']).to be_present
        expect(json_response['total_price']).to eq(20.0)

        product_json = json_response['products'].first
        puts "product_json: #{product_json}"
        expect(product_json['id']).to eq(product.id)
        expect(product_json['name']).to eq(product.name)
        expect(product_json['quantity']).to eq(2)
        expect(product_json['unit_price']).to eq(10.0)
        expect(product_json['total_price']).to eq(20.0)
      end
    end
  end

  # Teste original do esqueleto, comentado para ser implementado depois

  # pending "TODO: Escreva os testes de comportamento do controller de carrinho necessários para cobrir a sua implmentação #{__FILE__}"
  # describe "POST /add_items" do
  #   let(:cart) { create(:cart) } # PARA usar factory depois
  #   let(:product) { create(:product, name: "Test Product", price: 10.0) }
  #   let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

  #   context 'when the product already is in the cart' do
  #     subject do
  #       post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
  #       post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
  #     end

  #     it 'updates the quantity of the existing item in the cart' do
  #       expect { subject }.to change { cart_item.reload.quantity }.by(2)
  #     end
  #   end
  # end
end
