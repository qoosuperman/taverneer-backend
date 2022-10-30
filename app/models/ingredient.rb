# frozen_string_literal: true

class Ingredient < ApplicationRecord
  has_many :recipe_ingredients, dependent: :restrict_with_exception
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true, uniqueness: true
end
