# frozen_string_literal: true

RSpec.describe Recipe, type: :model do
  describe 'aasm' do
    describe '#publish!' do
      subject do
        travel_to(DateTime.new(1991, 2, 23)) do
          recipe.publish!
        end
      end

      context 'when recipe is draft' do
        let(:recipe) { create(:recipe) }

        it 'changes publish_state and updates published_at' do
          expect { subject }.to change { recipe.reload.publish_state }
            .from('draft')
            .to('published')
            .and change { recipe.reload.published_at }
            .from(nil)
            .to(DateTime.new(1991, 2, 23))
        end
      end

      context 'when recipe is published' do
        let(:recipe) { create(:recipe, :published) }

        it { expect { subject }.to raise_error(AASM::InvalidTransition) }
      end
    end

    describe '#unpublish!' do
      subject { recipe.unpublish! }

      context 'when recipe is published' do
        let(:recipe) { create(:recipe, :published) }

        it 'changes publish_state can nullifies published_at' do
          expect { subject }.to change { recipe.reload.publish_state }
            .from('published')
            .to('unpublished')
            .and change { recipe.reload.published_at }
            .from(be_present)
            .to(nil)
        end
      end

      context 'when recipe is unpublished' do
        let(:recipe) { create(:recipe, publish_state: 'unpublished') }

        it { expect { subject }.to raise_error(AASM::InvalidTransition) }
      end
    end
  end
end
