# frozen_string_literal: true

module RequestHelper
  def sign_in(user)
    allow_any_instance_of(Warden::SessionSerializer).to receive(:fetch).and_return(user)
  end

  def json_body
    JSON.parse(response.body, symbolize_names: true)
  end
end
