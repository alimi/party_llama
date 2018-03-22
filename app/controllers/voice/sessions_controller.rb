class Voice::SessionsController < Voice::ApplicationController
  def new
    render xml: VoiceXML.new(
      message: "Welcome to the wedding hotline! Please say or enter your reservation code.",
      next_path: voice_sessions_path
    )
  end

  def create
    input = VoiceInput.new(voice_params).to_s
    party = Party.find_by(reservation_code: input)

    if party
      render xml: VoiceXML.new(
        next_path: voice_session_verifications_path(party),
        message: "Are we speaking with #{party.name}?"
      )
    else
      render xml: VoiceXML.new(
        message: "Sorry, we couldn't find your reservation. Please re-enter your reservation code.",
        next_path: voice_sessions_path
      )
    end
  end

  private

  def voice_params
    params.slice("Digits", "SpeechResult", "Confidence").permit!
  end
end
