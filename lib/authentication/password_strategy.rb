# frozen_string_literal: true

require 'warden'

# warden 處理 authenticate 的分式是在 middleware 先把處理驗證的 proxy 放到 request env 再讓 application 使用 proxy 去做驗證
# proxy 驗證的方式就是客製自己的 strategy
# devise 也是透過這種方式做驗證 ref: https://github.com/heartcombo/devise/blob/main/lib/devise/models/database_authenticatable.rb

module Authentication
  class PasswordStrategy < Warden::Strategies::Base
    def valid?
      password.present? && email.present?
    end

    def authenticate!
      user = User.find_by(email: email)

      # NOTE: 這裡的 fail 不是 raise error 的意思，因此不適用這兩個 cop
      # rubocop:disable Style/GuardClause
      # rubocop:disable Style/SignalException
      fail('Could not log in!') if user.nil?

      if user.authenticate(password)
        success!(user)
      else
        fail('Could not log in!')
      end
      # rubocop:enable Style/GuardClause
      # rubocop:enable Style/SignalException
    end

    private

    def valid_params?
      params_auth_hash.is_a?(Hash)
    end

    def params_auth_hash
      if Rails.env.test?
        params['user']
      else
        @env["action_dispatch.request.parameters"]['user']
      end
    end

    def password
      @password ||= params_auth_hash['password']
    end

    def email
      @email ||= params_auth_hash['email']
    end
  end
end
