# frozen_string_literal: true

module FlashHelper
  def render_flash_messages
    render partial: 'shared/flash_messages'
  end

  def css_class_for_flash(type:)
    case type.to_sym
    when :success then 'alert-success'
    when :error then 'alert-danger'
    when :alert then 'alert-warning'
    when :notice then 'alert-info'
    else "alert-#{type}"
    end
  end
end
