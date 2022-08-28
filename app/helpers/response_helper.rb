# frozen_string_literal: true

module ResponseHelper
  extend ActiveSupport::Concern

  def respond_with_json(status:, **hsh)
    render json: {
      status: status
    }.merge(hsh), status: status
  end
end
