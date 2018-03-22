class Voice::VerificationsController < Voice::ApplicationController
  def create
    input = VoiceInput.new(voice_params).to_s

    if ["Yes.", "1"].include?(input)
      render xml: VoiceXML.new(message: "Yay! Smell you later!")
    elsif ["No.", "0"].include?(input)
      render xml: VoiceXML.new(
        next_path: voice_sessions_path,
        message: "Hmm, sorry about that. Please say or enter your reservation code."
      )
    else
      render xml: VoiceXML.new(
        next_path: voice_session_verifications_path(party),
        message: "Sorry, I didn't understand you. Are we speaking with #{party.name}?"
      )
    end
  end

  private

  def voice_params
    params.slice("Digits", "SpeechResult", "Confidence").permit!
  end

  def party
    @party ||= Party.find(params[:session_id])
  end
end
