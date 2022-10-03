# frozen_string_literal: true

RSpec.describe 'Api::V1::SessionsController', type: :request do
  let!(:user) do
    create(:user, email: 'coolguy@gmail.com', password: 'password1234')
  end

  describe 'users#sign_in' do
    subject { post api_v1_users_sign_in_path, params: params }

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
                                  message: 'Success!'
                                })
      end

      it 'stores user in request env' do
        subject
        expect(response.request.env['warden'].user).to eq(user)
      end

      it 'stores user in session' do
        subject
        expect(session['warden.user.default.key']).to eq(user.id)
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
                                  status: 'unauthorized',
                                  message: 'Unauthorized'
                                })
      end

      it 'does not stores user in request env' do
        subject
        expect(response.request.env['warden'].user).to be_nil
      end
    end
  end

  describe 'users#sign_out' do
    subject { delete api_v1_users_sign_out_path, params: params }

    let(:params) { {} }

    context 'when user already logged in' do
      before { login_as(user) }

      it 'signs out successfully' do
        subject
        expect(response).to have_http_status(:ok)
        expect(json_body).to eq({
                                  status: 'ok',
                                  message: 'Success!'
                                })
      end

      it 'clears data in session' do
        subject
        expect(session['warden.user.default.key']).to be_nil
      end
    end

    context 'when user not logged in' do
      it 'responds with 400' do
        subject
        expect(response).to have_http_status(:bad_request)
        expect(json_body).to eq({
                                  status: 'bad_request',
                                  message: 'User Not Logged In!'
                                })
      end
    end
  end
end
