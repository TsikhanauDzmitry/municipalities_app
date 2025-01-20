# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  subject(:address) { build(:address) }

  context 'when using a valid factory' do
    it { is_expected.to be_valid }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:street) }
    it { is_expected.to validate_presence_of(:zip_code) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
