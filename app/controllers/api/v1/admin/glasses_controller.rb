# frozen_string_literal: true

module Api
  module V1
    module Admin
      class GlassesController < BaseController
        before_action :set_glass, only: [:update, :destroy]

        def create
          glass = Glass.new(glass_params)
          if glass.save
            render json: { message: '新增成功！' }, status: :ok
          else
            render json: { message: '新增失敗！' }, status: :unprocessable_entity
          end
        end

        def update
          @glass.attributes = glass_params
          if @glass.save
            render json: { message: '更新成功！' }, status: :ok
          else
            render json: { message: '更新失敗！' }, status: :unprocessable_entity
          end
        end

        def destroy
          if @glass.destroy
            render json: { message: '刪除成功！' }, status: :ok
          else
            render json: { message: '刪除失敗！' }, status: :unprocessable_entity
          end
        end

        private

        def set_glass
          @glass = Glass.find(params[:id])
        end

        def glass_params
          params.require(:glass)
                .permit(:name)
        end
      end
    end
  end
end
