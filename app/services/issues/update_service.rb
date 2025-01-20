# frozen_string_literal: true

module Issues
  class UpdateService
    def initialize(issue:, field_name:, data:, current_user:)
      @issue = issue
      @field_name = field_name
      @data = data
      @current_user = current_user
    end

    def call
      return message_response(type: :unauthorized_response) if @current_user.resident?

      update_issue
    end

    private

    attr_reader :field_name, :data, :current_user, :issue

    ALLOWED_FLASH_TYPES = %i[success alert].freeze

    def update_issue
      @issue.update(@field_name => @data)

      message_response(type: :success)
    rescue ArgumentError => e
      Rails.logger.error("UpdateService Error: #{e.message}")
      message_response(type: :alert)
    end

    def message_response(type:)
      { flash: { type: get_flash_type(type:), message: get_message(type:) } }
    end

    def get_message(type:)
      case type
      when :success
        I18n.t('issues.controller.update_success', field: @field_name.to_s.humanize)
      when :alert
        I18n.t('issues.controller.update_failure', field: @field_name.to_s.humanize)
      when :unauthorized_response
        I18n.t('issues.controller.not_responsibility')
      else
        I18n.t('controller.flash_messages.smth_went_wrong')
      end
    end

    def get_flash_type(type:)
      ALLOWED_FLASH_TYPES.include?(type) ? type : :alert
    end
  end
end
