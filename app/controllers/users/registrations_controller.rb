# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: :create

    def new
      build_resource({})
      resource.build_profile
      resource.build_address
      respond_with(resource)
    end

    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [
                                          profile_attributes: %i[first_name last_name],
                                          address_attributes: %i[country city street zip_code]
                                        ])
    end
  end
end
