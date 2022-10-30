# frozen_string_literal: true

class CreateBasicTables < ActiveRecord::Migration[7.0]
  def change
    create_table :cocktails do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :ancestry
      t.text :description

      t.timestamps
    end

    create_table :glasses do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end

    create_table :recipes do |t|
      t.references :cocktail, foreign_key: true, null: false
      t.references :glass, foreign_key: true, null: false

      t.timestamps
    end

    create_table :ingredients do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end

    create_table :recipe_ingredients do |t|
      t.references :recipe, foreign_key: true, null: false
      t.references :ingredient, foreign_key: true, null: false
      t.string :amount, null: false

      t.timestamps
    end
    add_index :recipe_ingredients, [:recipe_id, :ingredient_id], unique: true

    create_table :steps do |t|
      t.references :recipe, foreign_key: true, null: false
      t.integer :position, default: 0, null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end
