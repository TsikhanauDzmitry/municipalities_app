# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def authenticate_admin_user!
    authenticate_user!

    redirect_to root_path, flash: { alert: I18n.t('controller.flash_messages.non_admin') } unless current_user.admin?
  end
end
