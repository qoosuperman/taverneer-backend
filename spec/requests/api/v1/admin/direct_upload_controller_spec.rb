# frozen_string_literal: true

RSpec.describe 'Api::V1::Admin::GlassesController', type: :request do
  describe '#create' do
    subject { post api_v1_admin_direct_upload_path, params:, as: :json }

    let(:params) do
      {
        input: {
          filename: 'my file',
          byte_size: '123',
          checksum:,
          content_type: 'image/jpeg'
        }
      }
    end
    let(:file) { File.open('spec/fixtures/aaa.jpeg') }
    let(:checksum) { Digest::SHA256.file(file).hexdigest }

    it_behaves_like 'cannot access by normal user'

    context 'when logged in as admin user' do
      let(:me) { create(:user, :admin) }

      before { login_as(me) }

      context 'with valid params' do
        it 'creates successfully' do
          expect { subject }.to change(ActiveStorage::Blob, :count).by(+1)
          expect(response).to have_http_status(:ok)
          expect(json_body).to match(
            {
              direct_upload: {
                url: be_a(String),
                headers: be_a(String),
                blob_id: be_a(Integer),
                signed_blob_id: be_a(String)
              }
            }
          )
        end
      end

      context 'with invalid params' do
        let(:params) do
          {
            glass: {
              name: 'new glass'
            }
          }
        end

        it 'gets error reponse' do
          expect { subject }.not_to change(ActiveStorage::Blob, :count)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_body).to match(
            {
              message: '參數錯誤'
            }
          )
        end
      end
    end
  end
end
