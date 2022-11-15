# frozen_string_literal: true

RSpec.describe Cocktail, type: :model do
  describe '#twists' do
    subject { cocktail.twists }

    let(:cocktail) { create(:cocktail) }
    let!(:child_cocktail_1) { create(:cocktail, parent: cocktail) }
    let!(:child_cocktail_2) { create(:cocktail, parent: cocktail) }

    it 'behaves the same as descendants' do
      expect(subject).to match([child_cocktail_1, child_cocktail_2])
    end
  end
end
