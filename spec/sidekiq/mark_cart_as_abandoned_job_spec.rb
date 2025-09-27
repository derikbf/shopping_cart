# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  include ActiveJob::TestHelper

  it "marks inactive carts as 'abandoned'" do
    create(:cart, status: 'active', last_interaction_at: 4.hours.ago)
    recent_cart = create(:cart, status: 'active', last_interaction_at: 1.hour.ago)

    described_class.new.perform

    expect(Cart.first.status).to eq('abandoned')
    expect(recent_cart.reload.status).to eq('active')
  end

  it "deletes carts that have been abandoned for more than 7 days" do
    create(:cart, status: 'abandoned', last_interaction_at: 8.days.ago)
    create(:cart, status: 'abandoned', last_interaction_at: 1.day.ago)

    expect {
      described_class.new.perform
    }.to change(Cart, :count).by(-1)
  end
end
