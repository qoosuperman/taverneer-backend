# frozen_string_literal: true

RSpec.shared_examples_for 'cannot access by normal user' do
  context 'when not logged in' do
    let(:me) { create(:user) }

    it_behaves_like 'AccessDeniedError'
  end

  context 'when logged in but not an admin' do
    let(:me) { create(:user) }

    before { login_as(me) }

    it_behaves_like 'AccessDeniedError'
  end
end
