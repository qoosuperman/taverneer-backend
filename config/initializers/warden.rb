# frozen_string_literal: true

Warden::Strategies.add(:password, Authentication::PasswordStrategy)

Warden::Manager.serialize_into_session(&:id)

Warden::Manager.serialize_from_session do |id|
  User.find(id)
end

module Warden
  module Mixins
    module Common
      def request
        @request ||= ActionDispatch::Request.new(env)
      end
    end
  end
end
