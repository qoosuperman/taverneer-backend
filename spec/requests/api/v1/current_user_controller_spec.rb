# frozen_string_literal: true

RSpec.describe 'Api::V1::CurrentUserController', type: :request do
  let(:user) { create(:user, name: 'qoosuperman') }

  describe '#index' do
    subject { get api_v1_current_user_path }

    context 'when already logged in' do
      before do
        sign_in(user)
      end

      context 'when user is not admin' do
        it 'gets ok response and is_admin: false' do
          subject
          expect(response).to have_http_status(:ok)
          expect(json_body).to match({
                                       status: 'ok',
                                       user: { name: 'qoosuperman', is_admin: false }
                                     })
        end
      end

      context 'when user is admin' do
        let(:user) { create(:user, :admin, name: 'qoosuperman') }

        it 'gets ok response and is_admin: true' do
          subject
          expect(response).to have_http_status(:ok)
          expect(json_body).to match({
                                       status: 'ok',
                                       user: { name: 'qoosuperman', is_admin: true }
                                     })
        end
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
