# frozen_string_literal: true

RSpec.describe 'Api::V1::Admin::RecipesController', type: :request do
  describe '#create' do
    subject { post api_v1_admin_recipes_path, params: params, as: :json }

    let!(:parent_cocktail) { create(:cocktail, name: 'parent') }
    let!(:first_ingredient) { create(:ingredient, name: 'first') }
    let!(:second_ingredient) { create(:ingredient, name: 'second') }
    let!(:glass) { create(:glass, name: 'correct glass') }
    let(:params) do
      {
        recipe: {
          cocktail: {
            name: 'Gin tonic',
            twist_id: parent_cocktail.id,
            description: 'This is a good cocktail'
          },
          ingredients: [
            {
              name: first_ingredient.name,
              amount: '1 oz'
            },
            {
              name: second_ingredient.name,
              amount: '1 drop'
            }
          ],
          steps: [
            {
              description: '先將杯子做冰杯，放在冷凍庫半小時以上'
            },
            {
              description: '加入八分滿冰塊'
            },
            {
              description: '倒入琴酒'
            },
            {
              description: '倒入通寧水'
            }
          ],
          glass_id: glass.id
        }
      }
    end

    it_behaves_like 'cannot access by normal user'

    context 'when logged in as admin user' do
      let(:me) { create(:user, :admin) }

      before { login_as(me) }

      context 'with proper params' do
        it 'creates recipe and related records successfully' do
          expect { subject }.to change(Recipe, :count)
            .by(+1)
            .and change(Cocktail, :count)
            .by(+1)
            .and change(RecipeIngredient, :count)
            .by(+2)
            .and change(Step, :count)
            .by(+4)
        end
      end

      context 'with invalid params' do
        let(:params) do
          {
            recipe: {
              cocktail: {
                name: 'Gin tonic',
                twist_id: parent_cocktail.id,
                description: 'This is a good cocktail'
              },
              ingredients: [
                {
                  name: first_ingredient.name,
                  amount: '隨意'
                },
                {
                  name: second_ingredient.name,
                  amount: '1 drop'
                }
              ],
              steps: [
                {
                  description: '先將杯子做冰杯，放在冷凍庫半小時以上'
                },
                {
                  description: '加入八分滿冰塊'
                },
                {
                  description: '倒入琴酒'
                }
              ],
              glass_id: glass.id
            }
          }
        end

        it 'creates recipe and related records successfully' do
          expect { subject }.not_to change(Recipe, :count)
          expect(json_body).to match(
            {
              message: {
                base: ['amount 必須為數字 + 單位，ex. "1 oz" 或者 "適量"']
              }
            }
          )
        end
      end
    end
  end

  describe '#update' do
    subject { patch api_v1_admin_recipe_path(id: recipe.id), params: params, as: :json }

    let!(:recipe) { create(:recipe, glass: original_glass) }
    let!(:cockatil) do
      create(:cocktail, name: 'Gin Tonic', description: 'just Gin Tonic', parent: original_parent)
    end

    let!(:original_parent) { create(:cocktail) }
    let!(:original_glass) { create(:glass) }
    let!(:step_1) { create(:step, position: 1, description: 'step1', recipe: recipe) }
    let!(:step_2) { create(:step, position: 2, description: 'step2', recipe: recipe) }
    let!(:recipe_ingredient_1) { create(:recipe_ingredient, recipe: recipe, ingredient: create(:ingredient)) }
    let!(:recipe_ingredient_2) { create(:recipe_ingredient, recipe: recipe, ingredient: create(:ingredient)) }
    let(:new_parent_cocktail) { create(:cocktail) }
    let(:params) do
      {
        recipe: {
          cocktail: {
            name: 'Gin Tonic',
            twist_id: new_parent_cocktail.id,
            description: 'This is a good cocktail'
          },
          steps:
          [
            {
              description: 'new step'
            },
            {
              id: step_1.id,
              description: step_1.description,
              _destroy: true
            },
            {
              id: step_2.id,
              description: 'new description for step_2'
            }
          ],
          ingredients:
          [
            {
              id: recipe_ingredient_1.id,
              amount: '2 oz'
            },
            {
              name: 'new ingredient',
              amount: '1 oz'
            },
            {
              id: recipe_ingredient_2.id,
              amount: recipe_ingredient_2.amount,
              _destroy: true
            }
          ]
        }
      }
    end

    it_behaves_like 'cannot access by normal user'

    context 'when logged in as admin user' do
      let(:me) { create(:user, :admin) }

      before { login_as(me) }

      context 'with proper params' do
        it 'creates recipe and related records successfully' do
          subject
          expect(response).to have_http_status(:ok)
          expect(recipe.reload.cocktail)
            .to have_attributes({
                                  ancestry: new_parent_cocktail.id.to_s,
                                  description: 'This is a good cocktail'
                                })
          expect(recipe.reload.steps.map { |s| s.slice(:position, :description) })
            .to match_array([
                              {
                                position: 1,
                                description: 'new step'
                              },
                              {
                                position: 2,
                                description: 'new description for step_2'
                              }
                            ])
          expect(recipe.reload.recipe_ingredients.map { |ri| ri.slice(:ingredient_id, :amount) })
            .to match_array([
                              {
                                amount: '2 oz',
                                ingredient_id: recipe_ingredient_1.ingredient.id
                              },
                              {
                                amount: '1 oz',
                                ingredient_id: be_an(Integer)
                              }

                            ])
        end
      end

      context 'with invalid params' do
        let(:params) do
          {
            recipe: {
              cocktail: {
                name: 'Gin Tonic',
                twist_id: new_parent_cocktail.id,
                description: 'This is a good cocktail'
              },
              ingredients:
              [
                {
                  id: recipe_ingredient_1.id,
                  amount: '2oz'
                }
              ]
            }
          }
        end

        it 'creates recipe and related records successfully' do
          expect { subject }.not_to change(Recipe, :count)
          expect(json_body).to match(
            {
              message: {
                base: ['amount 必須為數字 + 單位，ex. "1 oz" 或者 "適量"']
              }
            }
          )
        end
      end
    end
  end

  describe '#destroy' do
    subject { delete api_v1_admin_recipe_path(id: recipe.id) }

    let!(:recipe) { create(:recipe) }

    it_behaves_like 'cannot access by normal user'

    context 'when logged in as admin user' do
      let(:me) { create(:user, :admin) }

      before { login_as(me) }

      it 'deletes succesfully' do
        expect { subject }.to change(Recipe, :count).by(-1)
        expect(json_body).to match(
          {
            message: '刪除成功！'
          }
        )
      end
    end
  end
end
