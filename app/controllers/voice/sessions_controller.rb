class Voice::SessionsController < Voice::ApplicationController
  def new
    prefix = params[:prefix] || "Welcome to the wedding hotline!"
    message = "#{prefix} Please say or enter your reservation code."

    render xml: VoiceXML.new(message: message, next_path: voice_sessions_path)
  end

  def create
    input = VoiceInput.new(voice_params).to_s
    party = Party.find_by(reservation_code: input)

    if party
      redirect_to new_voice_session_verification_path(party)
    else
      redirect_to new_voice_session_path(
        prefix: "Sorry, we couldn't find your reservation."
      )
    end
  end

  private

  def voice_params
    params.slice("Digits", "SpeechResult", "Confidence").permit!
  end
end
