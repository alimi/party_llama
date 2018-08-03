module AdminAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  def authenticate
    authenticate_or_request_with_http_digest(
      Rails.application.credentials.admin_realm
    ) do |username|
      admins[username]&.password
    end
  end

  def admins
    @admins ||= Rails.application.credentials.admins.values.
      map { |credentials| Admin.new(credentials[:username], credentials[:password]) }.
      index_by(&:username)
  end

  Admin = Struct.new(:username, :password)
end
