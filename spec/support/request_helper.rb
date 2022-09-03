# frozen_string_literal: true

module RequestHelper
  def json_body
    JSON.parse(response.body, symbolize_names: true)
  end
end
