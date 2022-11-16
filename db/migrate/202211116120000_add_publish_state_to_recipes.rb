# frozen_string_literal: true

class AddPublishStateToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :publish_state, :publish_state, null: false, default: 'draft'
    add_index :recipes, :publish_state
  end
end
