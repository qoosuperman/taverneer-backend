# frozen_string_literal: true

RSpec.describe 'Api::V1::Admin::GlassesController', type: :request do
  describe '#create' do
    subject { post api_v1_admin_glasses_path, params: params, as: :json }

    let(:params) do
      {
        glass: {
          name: 'new glass'
        }
      }
    end

    it_behaves_like 'cannot access by normal user'

    context 'when logged in as admin user' do
      let(:me) { create(:user, :admin) }

      before { login_as(me) }

      context 'with valid params' do
        it 'creates successfully' do
          expect { subject }.to change(Glass, :count).by(+1)
          expect(response).to have_http_status(:ok)
          expect(json_body).to match(
            {
              message: '新增成功！'
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

        before { create(:glass, name: 'new glass') }

        it 'gets error reponse' do
          expect { subject }.not_to change(Glass, :count)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_body).to match(
            {
              message: '新增失敗！'
            }
          )
        end
      end
    end
  end

  describe '#update' do
    subject { patch api_v1_admin_glass_path(id: glass.id), params: params, as: :json }

    let(:params) do
      {
        glass: {
          name: 'new name'
        }
      }
    end

    let!(:glass) { create(:glass, name: 'original glass') }

    it_behaves_like 'cannot access by normal user'

    context 'when logged in as admin user' do
      let(:me) { create(:user, :admin) }

      before { login_as(me) }

      context 'with valid params' do
        it 'updates glass successfully' do
          expect { subject }.to change { glass.reload.name }
            .from('original glass')
            .to('new name')
          expect(response).to have_http_status(:ok)
          expect(json_body).to match(
            {
              message: '更新成功！'
            }
          )
        end
      end

      context 'with invalid params' do
        let(:params) do
          {
            glass: {
              name: ''
            }
          }
        end

        it 'updates glass successfully' do
          expect { subject }.not_to change { glass.reload.name }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_body).to match(
            {
              message: '更新失敗！'
            }
          )
        end
      end
    end
  end

  describe '#destroy' do
    subject { delete api_v1_admin_glass_path(id: glass.id), as: :json }

    let!(:glass) { create(:glass, name: 'original glass') }

    it_behaves_like 'cannot access by normal user'

    context 'when logged in as admin user' do
      let(:me) { create(:user, :admin) }

      before { login_as(me) }

      it 'deletes glass successfully' do
        expect { subject }.to change(Glass, :count).by(-1)
        expect(response).to have_http_status(:ok)
        expect(json_body).to match(
          {
            message: '刪除成功！'
          }
        )
      end
    end
  end
end
