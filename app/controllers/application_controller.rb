# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ResponseHelper
  include Authentication::HelperMethods
end
