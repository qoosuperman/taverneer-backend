# frozen_string_literal: true

RSpec.describe RecipeIngredient, type: :model do
  describe 'validations' do
    subject { recipe_ingredient.valid? }

    context 'when amount is "適量"' do
      let(:recipe_ingredient) { build(:recipe_ingredient, amount: '適量') }

      it { is_expected.to be_truthy }
    end

    context 'when amount is number + unit' do
      let(:recipe_ingredient) { build(:recipe_ingredient, amount: '1 oz') }

      it { is_expected.to be_truthy }
    end

    context 'when amount is number only' do
      let(:recipe_ingredient) { build(:recipe_ingredient, amount: '1 ') }

      it { is_expected.to be_falsy }
    end
  end
end
