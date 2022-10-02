# frozen_string_literal: true

RSpec.describe Cocktail, type: :model do
  describe '#twists' do
    subject { cocktail.twists }

    let(:cocktail) { create(:cocktail) }
    let!(:child_cocktail1) { create(:cocktail, parent: cocktail) }
    let!(:child_cocktail2) { create(:cocktail, parent: cocktail) }

    it 'behaves the same as descendants' do
      expect(subject).to match([child_cocktail1, child_cocktail2])
    end
  end
end
