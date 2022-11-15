# frozen_string_literal: true

# when creates a recipe, it also creates the cocktail in current version
# when updates a recipe, the cocktail name must not be changed
# 前端需要給將步驟順序排好在陣列中方便後端排序, ex.
# [
#   {
#     description: 'new step'
#   },
#   {
#     id: step_1.id,
#     _destroy: true
#   },
#   {
#     id: step_2.id,
#     description: 'new description for step_2'
#   }
# ]

class RecipeForm < ApplicationForm
  def initialize(recipe)
    @recipe = recipe
    @cocktail = nil
    @steps = []
    @recipe_ingredients = []
    @mark_for_destruction_step_ids = []
    @mark_for_destruction_recipe_ingredient_ids = []
  end

  def attributes=(attrs)
    @cocktail = assign_cocktail_attributes(attrs[:cocktail]) if attrs[:cocktail]
    @recipe_ingredients = assign_ingredients_attributes(attrs[:ingredients]) if attrs[:ingredients]
    @steps = assign_steps_attributes(attrs[:steps]) if attrs[:steps]
    @recipe.glass_id = attrs[:glass_id] if attrs[:glass_id]
  end

  def save
    ActiveRecord::Base.transaction do
      Step.where(id: @mark_for_destruction_step_ids).destroy_all
      RecipeIngredient.where(id: @mark_for_destruction_recipe_ingredient_ids).destroy_all
      @cocktail&.save!
      # skip uniqueness validation of position
      @steps.each do |step|
        step.save!(validate: false)
      end
      @recipe_ingredients.each(&:save!)
      @recipe.save!
    end
  end

  private

  def assign_cocktail_attributes(attrs)
    cocktail = Cocktail.find_by(name: attrs[:name])
    if @recipe.new_record?
      cocktail = Cocktail.new
    else
      raise ActiveRecord::RecordNotFound unless cocktail
    end
    # twist_id could be nil
    parent_id = attrs.delete(:twist_id)
    parent = parent_id ? Cocktail.find(parent_id) : nil
    cocktail.attributes = attrs.merge(parent: parent)
    @recipe.cocktail = cocktail
    cocktail
  end

  def assign_ingredients_attributes(attrs)
    attrs.filter_map do |ingredient_attrs|
      if ingredient_attrs[:id]
        recipe_ingredient = @recipe.recipe_ingredients.find(ingredient_attrs[:id])
        if ingredient_attrs[:_destroy]
          @mark_for_destruction_recipe_ingredient_ids << recipe_ingredient.id
          next
        end
      else
        recipe_ingredient = @recipe.recipe_ingredients.build
      end

      new_attr = ingredient_attrs.slice(:amount)
      if ingredient_attrs[:name]
        ingredient = Ingredient.find_by(name: ingredient_attrs[:name]) || Ingredient.new(name: ingredient_attrs[:name])
        new_attr = new_attr.merge(ingredient: ingredient)
      end

      recipe_ingredient.attributes = new_attr
      recipe_ingredient
    end
  end

  def assign_steps_attributes(attrs)
    index = 1
    attrs.filter_map do |step_attrs|
      if step_attrs[:id]
        step = @recipe.steps.find(step_attrs[:id])
        if step_attrs[:_destroy]
          @mark_for_destruction_step_ids << step.id
          next
        end
      else
        step = @recipe.steps.build
      end
      step.attributes = { description: step_attrs[:description], position: index }
      index += 1
      step
    end
  end
end
