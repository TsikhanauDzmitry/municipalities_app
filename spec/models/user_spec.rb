# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  context 'when using a valid factory' do
    it { is_expected.to be_valid }
  end

  describe 'traits' do
    context 'when user is admin' do
      subject(:user) { create(:user, :admin) }

      it { is_expected.to be_valid }
      it { expect(user.role).to eq('admin') }
    end

    context 'when user is employee' do
      subject(:user) { create(:user, :employee) }

      it { is_expected.to be_valid }
      it { expect(user.role).to eq('employee') }
    end

    context 'when user is resident' do
      subject(:user) { create(:user, :resident) }

      it { is_expected.to be_valid }
      it { expect(user.role).to eq('resident') }
    end

    context 'when user is default' do
      subject(:user) { create(:user) }

      it { is_expected.to be_valid }
      it { expect(user.role).to eq('resident') }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to have_one(:profile).dependent(:destroy) }
    it { is_expected.to have_one(:address).dependent(:destroy) }
    it { is_expected.to have_many(:worked_issues) }
    it { is_expected.to have_many(:opened_issues) }
  end
end
