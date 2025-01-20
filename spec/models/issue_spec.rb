# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Issue, type: :model do
  subject(:issue) { build(:issue) }

  context 'when using a valid factory' do
    it { is_expected.to be_valid }
  end

  describe 'traits for statuses' do
    context 'when issue is open' do
      subject(:issue) { create(:issue, :open) }

      it { is_expected.to be_valid }
      it { expect(issue.status).to eq('open') }
    end

    context 'when issue is accepted' do
      subject(:issue) { create(:issue, :accepted) }

      it { is_expected.to be_valid }
      it { expect(issue.status).to eq('accepted') }
    end

    context 'when issue is in progress' do
      subject(:issue) { create(:issue, :in_progress) }

      it { is_expected.to be_valid }
      it { expect(issue.status).to eq('in_progress') }
    end

    context 'when issue is rejected' do
      subject(:issue) { create(:issue, :rejected) }

      it { is_expected.to be_valid }
      it { expect(issue.status).to eq('rejected') }
    end

    context 'when issue is closed' do
      subject(:issue) { create(:issue, :closed) }

      it { is_expected.to be_valid }
      it { expect(issue.status).to eq('closed') }
    end
  end

  describe 'traits for priorities' do
    context 'when issue has low priority' do
      subject(:issue) { create(:issue, :low_priority) }

      it { is_expected.to be_valid }
      it { expect(issue.priority).to eq('low') }
    end

    context 'when issue has medium priority' do
      subject(:issue) { create(:issue, :medium_priority) }

      it { is_expected.to be_valid }
      it { expect(issue.priority).to eq('medium') }
    end

    context 'when issue has high priority' do
      subject(:issue) { create(:issue, :high_priority) }

      it { is_expected.to be_valid }
      it { expect(issue.priority).to eq('high') }
    end
  end

  describe 'with image' do
    subject(:issue) { create(:issue, :with_image) }

    it { is_expected.to be_valid }

    it 'attaches an image' do
      expect(issue.image).to be_attached
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:priority) }

    it { is_expected.to validate_content_type_of(:image).allowing('image/png', 'image/jpeg', 'image/jpg') }
    it { is_expected.to validate_size_of(:image).less_than(5.megabytes) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:creator).class_name('User').with_foreign_key(:created_by) }
    it { is_expected.to belong_to(:worker).class_name('User').optional }
  end
end
