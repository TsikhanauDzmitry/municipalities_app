# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile, type: :model do
  subject(:profile) { build(:profile) }

  context 'when using a valid factory' do
    it { is_expected.to be_valid }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
