# frozen_string_literal: true

RSpec.describe 'Api::V1::CurrentUserController', type: :request do
  let(:user) { create(:user, name: 'qoosuperman') }

  describe '#index' do
    subject { get api_v1_current_user_path }

    context 'when already logged in' do
      before do
        allow_any_instance_of(Warden::SessionSerializer).to receive(:fetch).and_return(user)
      end

      it 'gets ok response' do
        subject
        expect(response).to have_http_status(:ok)
        expect(json_body).to match({
                                     status: 'ok',
                                     user: { name: 'qoosuperman' }
                                   })
      end
    end

    context 'when not login yet' do
      it 'gets not found response' do
        subject
        expect(response).to have_http_status(:not_found)
        expect(json_body).to match({
                                     status: 'not_found',
                                     message: 'Not Found'
                                   })
      end
    end
  end
end
