# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      class SessionUserNotFoundError < StandardError
      end

      def create
        user = warden.authenticate!
        sign_in(user)
        respond_with_json(status: :created, message: 'Success!')
      end

      def destroy
        user = session['warden.user.default.key']
        raise SessionUserNotFoundError, 'User Not Found' unless user

        sign_out(user)
        respond_with_json(status: :ok, message: 'Success!')
      rescue SessionUserNotFoundError
        respond_with_json(status: :bad_request, message: 'User Not Logged In!')
      end

      private

      def sign_in(user)
        # 如果使用者已經登入就不做事
        if warden.user == user
          true
        else
          warden.set_user(user)
        end
      end

      # warden 裡面登出只需要 scope
      # 但未來 user 可能有需要做額外處理
      def sign_out(_user)
        warden.logout(:default) # default 為 scope
      end
    end
  end
end
