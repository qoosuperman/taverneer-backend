# frozen_string_literal: true

module Api
  module V1
    module Admin
      class IngredientsController < BaseController
        before_action :set_ingredient, only: [:update, :destroy]

        def index
          @ingredients = Ingredient.order(:id)
          render formats: [:json]
        end

        def show
          @ingredient = Ingredient.find(params[:id])
          render formats: [:json]
        end

        def create
          ingredient = Ingredient.new(ingredient_params)
          if ingredient.save
            render json: { message: '新增成功！' }, status: :ok
          else
            render json: { message: '新增失敗！' }, status: :unprocessable_entity
          end
        end

        def update
          @ingredient.attributes = ingredient_params
          if @ingredient.save
            render json: { message: '更新成功！' }, status: :ok
          else
            render json: { message: '更新失敗！' }, status: :unprocessable_entity
          end
        end

        def destroy
          if @ingredient.destroy
            render json: { message: '刪除成功！' }, status: :ok
          else
            render json: { message: '刪除失敗！' }, status: :unprocessable_entity
          end
        end

        private

        def set_ingredient
          @ingredient = Ingredient.find(params[:id])
        end

        def ingredient_params
          params.require(:ingredient)
                .permit(:name)
        end
      end
    end
  end
end
