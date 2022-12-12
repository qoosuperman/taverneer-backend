# frozen_string_literal: true

module Api
  module V1
    module Admin
      class RecipesController < BaseController
        before_action :set_recipe, only: [:update, :destroy]

        def create
          recipe = Recipe.new
          form = RecipeForm.new(recipe)
          form.attributes = recipe_params
          if form.save
            render json: { message: '新增成功！' }, status: :ok
          else
            render json: { message: '新增失敗！' }, status: :unprocessable_entity
          end
        end

        def update
          form = RecipeForm.new(@recipe)
          form.attributes = recipe_params
          if form.save
            render json: { message: '更新成功！' }, status: :ok
          else
            render json: { message: '更新失敗！' }, status: :unprocessable_entity
          end
        end

        def destroy
          if @recipe.destroy
            render json: { message: '刪除成功！' }, status: :ok
          else
            render json: { message: '刪除失敗！' }, status: :unprocessable_entity
          end
        end

        private

        def set_recipe
          @recipe = Recipe.find(params[:id])
        end

        def recipe_params
          params.require(:recipe)
                .permit(:glass_id, cocktail: [:name, :twist_id, :description],
                                   ingredients: [:id, :name, :amount, :_destroy],
                                   steps: [:id, :description, :_destroy])
        end
      end
    end
  end
end
