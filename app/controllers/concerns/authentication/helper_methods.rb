# frozen_string_literal: true

module Authentication
  module HelperMethods
    def current_user
      warden.user
    end

    def warden
      request.env['warden']
    end
  end
end
