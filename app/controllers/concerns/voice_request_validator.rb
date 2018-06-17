module VoiceRequestValidator
  extend ActiveSupport::Concern

  included do
    skip_before_action :verify_authenticity_token
    before_action :validate_request
  end

  def validate_request
    return true if Rails.env.test?
    return head :bad_request if missing_signature?

    result = validator.validate(
      request.url,
      request.request_parameters.sort.to_h,
      request.headers["X-Twilio-Signature"]
    )

    head :bad_request unless result
  end

  def missing_signature?
    request.headers["X-Twilio-Signature"].blank?
  end

  def validator
    Twilio::Security::RequestValidator.new(
      Rails.application.credentials.twilio_auth_token!
    )
  end
end
