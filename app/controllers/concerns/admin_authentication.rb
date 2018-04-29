module AdminAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  def authenticate
    authenticate_or_request_with_http_digest(
      Rails.application.credentials.admin_realm
    ) do |username|
      admins[username]&.authentication_hash
    end
  end

  def admins
    @admins ||=
      Rails.application.credentials.admins.values.
        map { |credentials| [credentials[:username], Admin.new(credentials)] }.
        to_h
  end
end
