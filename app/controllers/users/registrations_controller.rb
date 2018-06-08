# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    def edit
      @oauth = OAUTH_PROVIDERS.find { |oap| oap.label == resource.provider.to_sym }.name if resource.provider.present?
      super
    end

    protected

    def update_resource(resource, params)
      if needs_password?(resource, params)
        resource.update_with_password(params)
      else
        params.delete_if { |p| %i[current_password password password_confirmation].include?(p) }
        resource.update_without_password(params)
      end
    end

    private

    def needs_password?(resource, params)
      params[:password].present? || resource.encrypted_password.present?
    end
  end
end
