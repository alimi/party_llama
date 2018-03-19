class Voice::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    twilio_response = Twilio::TwiML::VoiceResponse.new do |response|
      response.gather action: voice_sessions_path, input: "dtmf speech" do |gather|
        gather.say "Welcome to the wedding hotline!"
        gather.say "Please enter your reservation code."
      end
    end

    render xml: twilio_response.to_s
  end

  def create
    party = Party.find_by(reservation_code: params['Digits'])

    if party
      twilio_response = Twilio::TwiML::VoiceResponse.new do |response|
        response.gather action: voice_session_verifications_path(party), input: "dtmf speech" do |gather|
          gather.say "Are we speaking with #{party.name}?"
        end
      end
    else
      twilio_response = Twilio::TwiML::VoiceResponse.new do |response|
        response.gather action: voice_sessions_path do |gather|
          gather.say "Sorry, we couldn't find your reservation."
          gather.say "Please re-enter your reservation code."
        end
      end
    end

    render xml: twilio_response.to_s
  end
end
