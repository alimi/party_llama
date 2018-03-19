class Voice::VerificationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    twilio_response = Twilio::TwiML::VoiceResponse.new do |response|
      response.say "Adios!"
      response.hangup
    end

    render xml: twilio_response.to_s
  end
end
