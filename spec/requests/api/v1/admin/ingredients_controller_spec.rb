# frozen_string_literal: true

RSpec.describe 'Api::V1::Admin::GlassesController', type: :request do
  describe '#index' do
    subject { get api_v1_admin_ingredients_path, as: :json }

    it_behaves_like 'cannot access by normal user'

    context 'when logged in as admin user' do
      let(:me) { create(:user, :admin) }

      before do
        login_as(me)
        create(:ingredient, name: 'ingredient 1')
        create(:ingredient, name: 'ingredient 2')
      end

      it 'renders successfully' do
        subject
        expect(json_body).to match(
          {
            ingredients: [
              {
                id: be_present,
                name: 'ingredient 1'
              },
              {
                id: be_present,
                name: 'ingredient 2'
              }
            ]
          }
        )
      end
    end
  end

  describe '#show' do
    subject { get api_v1_admin_ingredient_path(id: ingredient.id), as: :json }

    let(:ingredient) { create(:ingredient, name: 'new ingredient') }

    it_behaves_like 'cannot access by normal user'

    context 'when logged in as admin user' do
      let(:me) { create(:user, :admin) }

      before do
        login_as(me)
      end

      it 'renders successfully' do
        subject
        expect(json_body).to match(
          {
            ingredient:
              {
                id: be_present,
                name: 'new ingredient'
              }
          }
        )
      end
    end
  end

  describe '#create' do
    subject { post api_v1_admin_ingredients_path, as: :json, params: }

    let(:params) { { ingredient: { name: 'my new ingredient' } } }

    it_behaves_like 'cannot access by normal user'

    context 'when logged in as admin user' do
      let(:me) { create(:user, :admin) }

      before do
        login_as(me)
      end

      context 'when params is correct' do
        it 'creates successfully' do
          expect { subject }.to change(Ingredient, :count).by(1)
          expect(json_body).to match(
            {
              message: '新增成功！'
            }
          )
        end
      end

      context 'when params is incorrect' do
        let(:params) { { ingredient: { name: '' } } }

        it 'creates unsuccessfully' do
          expect { subject }.to change(Ingredient, :count).by(0)
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
    subject { patch api_v1_admin_ingredient_path(id: ingredient.id), as: :json, params: }

    let(:params) { { ingredient: { name: 'new name' } } }
    let(:ingredient) { create(:ingredient, name: 'origin ingredient') }

    it_behaves_like 'cannot access by normal user'

    context 'when logged in as admin user' do
      let(:me) { create(:user, :admin) }

      before do
        login_as(me)
      end

      context 'when params is correct' do
        it 'updates successfully' do
          expect { subject }.to change { ingredient.reload.name }.from('origin ingredient').to('new name')
          expect(json_body).to match(
            {
              message: '更新成功！'
            }
          )
        end
      end

      context 'when params is incorrect' do
        let(:params) { { ingredient: { name: '' } } }

        it 'updates unsuccessfully' do
          expect { subject }.not_to change { ingredient.reload.name }
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
    subject { delete api_v1_admin_ingredient_path(id: ingredient.id), as: :json }

    let!(:ingredient) { create(:ingredient, name: 'origin ingredient') }

    it_behaves_like 'cannot access by normal user'

    context 'when logged in as admin user' do
      let(:me) { create(:user, :admin) }

      before do
        login_as(me)
      end

      context 'when destroys succesfully' do
        it do
          expect { subject }.to change(Ingredient, :count).by(-1)
          expect(json_body).to match(
            {
              message: '刪除成功！'
            }
          )
        end
      end

      context 'when destroys unsuccesfully' do
        before do
          allow_any_instance_of(Ingredient).to receive(:destroy).and_return(false)
        end

        it 'updates unsuccessfully' do
          expect { subject }.not_to change(Ingredient, :count)
          expect(json_body).to match(
            {
              message: '刪除失敗！'
            }
          )
        end
      end
    end
  end
end
