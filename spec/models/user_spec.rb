# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { user.valid? }

    let(:user) { build(:user) }

    it { is_expected.to be_truthy }

    context 'when password is in incorrect format' do
      context 'with only 4 digit' do
        let(:user) { build(:user, password: 'pas1') }

        it { is_expected.to be_falsy }
      end

      context 'with no digit' do
        let(:user) { build(:user, password: 'passwordd') }

        it { is_expected.to be_falsy }
      end

      context 'with no character' do
        let(:user) { build(:user, password: '12345678') }

        it { is_expected.to be_falsy }
      end
    end

    context 'when email is in incorrect format' do
      let(:user) { build(:user, email: 'invalid email') }

      it { is_expected.to be_falsy }
    end

    context 'when name is empty' do
      let(:user) { build(:user, name: '') }

      it { is_expected.to be_falsy }
    end
  end
end
