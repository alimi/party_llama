class Voice::VerificationsController < Voice::ApplicationController
  include Voiceable

  def new
    prefix = params[:prefix] || ""
    message = "#{prefix} Are we speaking with #{party.name}?"

    render xml: VoiceXML.new(
      message: message,
      next_path: voice_session_verifications_path(party),
      expect: AffirmativeAndNegativeWords.to_s
    )
  end

  def create
    if voice_input.affirmative?
      process_verification
    elsif voice_input.negative?
      redirect_to new_voice_session_path(prefix: "Hmm, sorry about that.")
    else
      redirect_to new_voice_session_verification_path(
        party.id,
        prefix: "Sorry, I didn't understand you."
      )
    end
  end

  private

  def process_verification
    if party.passed_submission_deadline?
      render xml: VoiceXML.new(
        message: translate(".passed_submission_deadline")
      )
    else
      session[:current_party_id] = party.id
      redirect_to new_voice_party_response_path(venue: "patterson_park")
    end
  end

  def party
    @party ||= Party.find(params[:session_id])
  end
end
