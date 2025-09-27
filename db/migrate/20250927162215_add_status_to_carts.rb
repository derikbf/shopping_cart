# frozen_string_literal: true

class AddStatusToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :status, :string, default: 'active'
    add_column :carts, :last_interaction_at, :datetime
    
    add_index :carts, :status
  end
end
