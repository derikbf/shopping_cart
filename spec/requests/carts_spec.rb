# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/carts", type: :request do
  let!(:product) { create(:product, price: 10.0, name: "Super Gadget") }
  let!(:product1) { create(:product, price: 10.0, name: "Gadget") }
  let!(:product2) { create(:product, price: 25.0, name: "Widget") }

  describe "POST /cart (add_product)" do
    context "with valid parameters" do
      it "creates a cart, adds a new product, and returns the complete payload" do
        post '/cart', params: { product_id: product.id, quantity: 2 }, as: :json

        expect(response).to have_http_status(:created )
        
        json_response = JSON.parse(response.body)
        
        expect(json_response['id']).to be_present
        expect(json_response['total_price']).to eq(20.0)

        product_json = json_response['products'].first
        expect(product_json['id']).to eq(product.id)
        expect(product_json['name']).to eq("Super Gadget")
        expect(product_json['quantity']).to eq(2)
        expect(product_json['unit_price']).to eq(10.0)
        expect(product_json['total_price']).to eq(20.0)
      end

      it "increases the quantity when adding an existing product" do
        post '/cart', params: { product_id: product.id, quantity: 1 }, as: :json
        expect(response).to have_http_status(:created )

        post '/cart', params: { product_id: product.id, quantity: 3 }, as: :json
        expect(response).to have_http_status(:created )

        json_response = JSON.parse(response.body)
        
        expect(json_response['products'].count).to eq(1)
        expect(json_response['products'].first['quantity']).to eq(4)
        expect(json_response['total_price']).to eq(40.0)
      end
    end

    context "with invalid parameters" do
      it "returns an unprocessable_entity error if quantity is zero" do
        post '/cart', params: { product_id: product.id, quantity: 0 }, as: :json
        expect(response).to have_http_status(:unprocessable_entity )
      end

      it "returns an unprocessable_entity error if quantity is negative" do
        post '/cart', params: { product_id: product.id, quantity: -1 }, as: :json
        expect(response).to have_http_status(:unprocessable_entity )
      end

      it "returns a not_found error if product_id is invalid" do
        post '/cart', params: { product_id: 9999, quantity: 1 }, as: :json
        expect(response).to have_http_status(:not_found )
      end
    end
  end

  describe "GET /cart (show)" do
    context "when the cart is empty" do
      it "returns an empty cart structure" do
        get '/cart'

        expect(response).to have_http_status(:ok )
        json_response = JSON.parse(response.body)
        expect(json_response['products']).to be_empty
        expect(json_response['total_price']).to eq(0.0)
      end
    end

    context "when the cart has items" do
      before do
        post '/cart', params: { product_id: product1.id, quantity: 2 }, as: :json
        post '/cart', params: { product_id: product2.id, quantity: 1 }, as: :json
      end

      it "returns the cart with all its items" do
        get '/cart'

        expect(response).to have_http_status(:ok )
        json_response = JSON.parse(response.body)

        expect(json_response['products'].count).to eq(2)
        expect(json_response['total_price']).to eq(45.0)
        expect(json_response['products'].first['name']).to eq("Gadget")
      end
    end
  end

  describe "POST /cart/add_item (update_item)" do
    let!(:product) { create(:product, price: 10.0) }

    before do
      post '/cart', params: { product_id: product.id, quantity: 1 }, as: :json
    end

    context "with valid parameters" do
      it "updates the quantity only an existing product" do
        post '/cart/add_item', params: { product_id: product.id, quantity: 5 }, as: :json

        expect(response).to have_http_status(:ok )
        json_response = JSON.parse(response.body)

        expect(json_response['products'].first['quantity']).to eq(5)
        expect(json_response['total_price']).to eq(50.0)
      end
    end

    context "with invalid quantity" do
      it "removes the item if quantity is zero" do
        post '/cart/add_item', params: { product_id: product.id, quantity: 0 }, as: :json

        expect(response).to have_http_status(:ok )
        json_response = JSON.parse(response.body)
        expect(json_response['products']).to be_empty
      end

      it "returns an error if quantity is negative" do
        post '/cart/add_item', params: { product_id: product.id, quantity: -1 }, as: :json
        expect(response).to have_http_status(:unprocessable_entity )
      end
    end
  end

  describe "DELETE /cart/:product_id (remove_item)" do
    let!(:product_to_remove) { create(:product, price: 50.0) }

    before do
      post '/cart', params: { product_id: product_to_remove.id, quantity: 1 }, as: :json
    end

    context "when the product exists in the cart" do
      it "removes the product from the cart and returns the updated cart" do
        delete "/cart/#{product_to_remove.id}"

        expect(response).to have_http_status(:ok )
        json_response = JSON.parse(response.body)

        expect(json_response['products']).to be_empty
        expect(json_response['total_price']).to eq(0.0)
      end
    end

    context "when the product does not exist in the cart" do
      it "returns an error message and does not change the cart" do
        delete "/cart/9999"

        expect(response).to have_http_status(:not_found )
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Product not found in cart')

        get '/cart'
        final_cart_json = JSON.parse(response.body)
        expect(final_cart_json['products'].count).to eq(1)
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
