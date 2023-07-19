# frozen_string_literal: true

module Api
  module V1
    class CurrentUserController < ApplicationController
      def index
        if current_user
          respond_with_json(status: :ok, user: { name: current_user.name, is_admin: current_user.is_admin? })
        else
          respond_with_json(status: :not_found, message: 'Not Found')
        end
      end
    end
  end
end
