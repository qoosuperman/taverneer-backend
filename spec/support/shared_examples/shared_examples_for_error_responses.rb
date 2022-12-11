# frozen_string_literal: true

RSpec.shared_examples_for 'AccessDeniedError' do |error = {}|
  it 'responds with error with extensions.code AUTHORIZATION_ERROR' do
    subject

    expect(response).to have_http_status(:forbidden)
    expect(json_body).to eq({
      message: '由於缺少權限，無法進行此操作'
    }.merge(error))
  end
end
