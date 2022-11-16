# frozen_string_literal: true

class AddPublishStateAndPublishedAtToRecipes < ActiveRecord::Migration[7.0]
  def change
    change_table :recipes, bulk: true do |t|
      t.enum :publish_state, enum_type: :publish_state, null: false, default: 'draft'
      t.datetime :published_at
    end
    add_index :recipes, :publish_state
  end
end
