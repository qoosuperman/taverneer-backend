# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def create
        user = warden.authenticate!
        sign_in(user)
        respond_with_json(status: :created, message: 'success!')
      end

      def destroy; end

      private

      def sign_in(user)
        # 如果使用者已經登入就不做事
        if warden.user('user') == user
          true
        else
          warden.set_user(user)
        end
      end
    end
  end
end
