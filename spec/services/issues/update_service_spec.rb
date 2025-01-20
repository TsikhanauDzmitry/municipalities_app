# frozen_string_literal: true

module Issues
  RSpec.describe UpdateService do
    subject(:service) { described_class.new(issue:, field_name:, data:, current_user:) }

    describe '#call' do
      subject(:updated_issue) { service.call }

      let(:issue) { create(:issue, :open) }
      let(:current_user) { create(:user, :employee) }
      let(:field_name) { :status }
      let(:data) { 'closed' }

      context 'when user is resident' do
        let(:current_user) { create(:user, :resident) }

        it 'returns not_responsibility message' do
          expect(updated_issue[:flash][:message]).to eq(I18n.t('issues.controller.not_responsibility'))
        end

        it 'returns alert flash_type' do
          expect(updated_issue[:flash][:type]).to eq(:alert)
        end
      end

      context 'when user successfully updates status' do
        it 'returns success message' do
          expect(updated_issue[:flash][:message]).to eq(I18n.t('issues.controller.update_success', field: 'Status'))
        end

        it 'returns success flash_type' do
          expect(updated_issue[:flash][:type]).to eq(:success)
        end
      end

      context 'when user failed to update status' do
        let(:data) { 'non-valid-status' }

        it 'returns failed message' do
          expect(updated_issue[:flash][:message]).to eq(I18n.t('issues.controller.update_failure', field: 'Status'))
        end

        it 'returns alert flash_type' do
          expect(updated_issue[:flash][:type]).to eq(:alert)
        end
      end
    end
  end
end
