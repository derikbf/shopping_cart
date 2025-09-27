# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartItem, type: :model do
  context 'validations' do
    it 'is not valid with a quantity of zero' do
      cart_item = build(:cart_item, quantity: 0)
      expect(cart_item).not_to be_valid
    end

    it 'is not valid with a negative quantity' do
      cart_item = build(:cart_item, quantity: -1)
      expect(cart_item).not_to be_valid
    end

    it 'is valid with a positive quantity' do
      cart_item = build(:cart_item, quantity: 1)
      expect(cart_item).to be_valid
    end
  end
end
