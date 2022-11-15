# frozen_string_literal: true

RSpec.describe RecipeForm, type: :form do
  subject do
    form = described_class.new(recipe)
    form.attributes = params
    form.save
  end

  context 'when creates a new recipe' do
    let(:recipe) { Recipe.new }
    let!(:parent_cocktail) { create(:cocktail) }
    let!(:first_ingredient) { create(:ingredient, name: 'Gin') }
    let!(:second_ingredient) { create(:ingredient, name: 'Tonic Water') }
    let!(:glass) { create(:glass) }

    let(:params) do
      {
        cocktail: {
          name: 'Gin Tonic',
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
            amount: '200 ml'
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
    end

    context 'when valid' do
      it 'creates cocktails / recipe_ingredients and steps' do
        expect { subject }.to change(Cocktail, :count)
          .by(+1)
          .and change(RecipeIngredient, :count)
          .by(+2)
          .and change(Step, :count)
          .by(+4)
      end

      it 'created resources have correct attributes' do
        subject
        expect(Cocktail.last).to have_attributes(
          {
            name: 'Gin Tonic',
            description: 'This is a good cocktail',
            ancestry: parent_cocktail.id.to_s
          }
        )
        expect(Recipe.last).to have_attributes(
          {
            glass_id: glass.id
          }
        )
        expect(Recipe.last.steps.map { |r| r.slice(:position, :description) }).to match_array(
          [
            {
              position: 1,
              description: '先將杯子做冰杯，放在冷凍庫半小時以上'
            },
            {
              position: 2,
              description: '加入八分滿冰塊'
            },
            {
              position: 3,
              description: '倒入琴酒'
            },
            {
              position: 4,
              description: '倒入通寧水'
            }
          ]
        )
        expect(Recipe.last.recipe_ingredients.map { |ri| ri.slice(:amount, :ingredient_id) }).to match_array(
          [
            {
              ingredient_id: first_ingredient.id,
              amount: '1 oz'
            },
            {
              ingredient_id: second_ingredient.id,
              amount: '200 ml'
            }
          ]
        )
      end
    end

    context 'when cocktail name duplicates with another' do
      before { create(:cocktail, name: 'Gin Tonic') }

      it 'raises error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  context 'when updates an existed recipe' do
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

    context 'when only updates cocktail information' do
      let(:params) do
        {
          cocktail: {
            name: 'Gin Tonic',
            twist_id: nil,
            description: 'This is a good cocktail'
          }
        }
      end
      let(:new_parent_cocktail) { create(:cocktail) }

      it 'does change cocktail attributes' do
        expect { subject }.to change { cockatil.reload.ancestry }
          .from(original_parent.id.to_s)
          .to(nil)
          .and change { cockatil.reload.description }
          .from('just Gin Tonic')
          .to('This is a good cocktail')
      end
    end

    context 'when updates steps information' do
      context 'when deletes a step' do
        let(:params) do
          {
            steps:
            [
              {
                id: step_1.id,
                _destroy: true
              },
              {
                id: step_2.id,
                description: step_2.description
              }
            ]
          }
        end

        it 'destroys the step and updates position' do
          expect { subject }.to change(Step, :count)
            .by(-1)
            .and change { step_2.reload.position }
            .from(2)
            .to(1)
        end
      end

      context 'when updates a step' do
        let(:params) do
          {
            steps:
            [
              {
                id: step_1.id,
                description: 'new description for step_1'
              },
              {
                id: step_2.id,
                description: step_2.description
              }
            ]
          }
        end

        it 'updates the attribute' do
          expect { subject }.to change { step_1.reload.description }
            .from('step1')
            .to('new description for step_1')
        end
      end

      context 'when creates a step' do
        let(:params) do
          {
            steps:
            [
              {
                id: step_1.id,
                description: 'new description for step_1'
              },
              {
                description: 'new_step'
              },
              {
                id: step_2.id,
                description: step_2.description
              }
            ]
          }
        end

        it 'creates a step and updates index' do
          expect { subject }.to change { recipe.reload.steps.size }
            .from(2)
            .to(3)
            .and change { step_2.reload.position }.from(2).to(3)
          expect(Step.last.description).to eq('new_step')
        end
      end

      context 'when update / create and delete steps at same time' do
        let(:params) do
          {
            steps:
            [
              {
                description: 'new step'
              },
              {
                id: step_1.id,
                _destroy: true
              },
              {
                id: step_2.id,
                description: 'new description for step_2'
              }
            ]
          }
        end

        it { expect { subject }.not_to change(Step, :count) }

        it do
          subject
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
        end
      end
    end

    context 'when updates recipe ingredients' do
      context 'when deletes a recipe ingredient' do
        let(:params) do
          {
            ingredients:
            [
              {
                id: recipe_ingredient_1.id,
                _destroy: true
              }
            ]
          }
        end

        it { expect { subject }.to change(RecipeIngredient, :count).by(-1) }
      end

      context 'when updates an ingredient with new ingredient' do
        let(:params) do
          {
            ingredients:
            [
              {
                id: recipe_ingredient_1.id,
                name: 'new ingredient'
              }
            ]
          }
        end

        it 'creates an ingredient and change the ingredient_id of association' do
          expect { subject }.to change(Ingredient, :count)
            .by(+1)
            .and change { recipe_ingredient_1.reload.ingredient_id }
        end
      end

      context 'when creates a recipe ingredient with new ingredient' do
        let(:params) do
          {
            ingredients:
            [
              {
                name: 'new ingredient',
                amount: '1 oz'
              }
            ]
          }
        end

        it 'creates an ingredient and creates a new association' do
          expect { subject }.to change(Ingredient, :count)
            .by(+1)
            .and change(RecipeIngredient, :count).by(+1)
        end
      end

      context 'when updates / creates and deletes recipe_ingredient at same time' do
        let(:params) do
          {
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
                _destroy: true
              }
            ]
          }
        end

        it do
          expect { subject }.not_to change(RecipeIngredient, :count)
          expect(Ingredient.last.name).to eq('new ingredient')
          expect(recipe_ingredient_1.reload.amount).to eq('2 oz')
        end
      end
    end

    context 'when updates cocktails / steps / ingredients' do
      let(:params) do
        {
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
              _destroy: true
            }
          ]
        }
      end
      let(:new_parent_cocktail) { create(:cocktail) }

      it do
        subject
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
  end
end
