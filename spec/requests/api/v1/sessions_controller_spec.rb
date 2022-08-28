# frozen_string_literal: true

RSpec.describe 'Api::V1::SessionsController', type: :request do
  describe 'users#sign_in' do
    subject { post api_v1_users_sign_in_path, params: params }

    let!(:user) do
      create(:user, email: 'coolguy@gmail.com', password: 'password1234')
    end

    context 'when params is valid' do
      let(:params) do
        { user: {
          email: 'coolguy@gmail.com',
          password: 'password1234'
        } }
      end

      it 'gets created response' do
        subject
        expect(response).to have_http_status(:created)
        expect(json_body).to eq({
                                  status: 'created',
                                  message: 'success!'
                                })
      end

      it 'stores user in request env' do
        subject
        expect(response.request.env['warden'].user).to eq(user)
      end

      it 'stores user in session' do
        subject
        expect(session['warden.user.default.key']).to eq(user)
      end
    end

    context 'when password is wrong' do
      let(:params) do
        { user: {
          email: 'coolguy@gmail.com',
          password: 'password12345'
        } }
      end

      it 'gets error response' do
        subject
        expect(response).to have_http_status(:unauthorized)
        expect(json_body).to eq({
                                  status: 401,
                                  message: 'Unauthorized'
                                })
      end

      it 'does not stores user in request env' do
        subject
        expect(response.request.env['warden'].user).to be_nil
      end
    end
  end
end
