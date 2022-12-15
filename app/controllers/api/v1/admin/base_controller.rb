# frozen_string_literal: true

module Api
  module V1
    module Admin
      class BaseController < ApplicationController
        before_action :check_if_admin

        private

        def check_if_admin
          return if current_user&.admin?

          raise AccessDeniedError
        end
      end
    end
  end
end
