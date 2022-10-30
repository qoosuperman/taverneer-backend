# frozen_string_literal: true

class Recipe < ApplicationRecord
  belongs_to :cocktail
  belongs_to :glass
  has_many :steps, dependent: :destroy
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
end
