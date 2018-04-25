class Voice::SessionVerificationsController < Voice::ApplicationController
  include Voiceable
  include PartyAuthentication

  def new
    prefix = params[:prefix] || ""
    message = "#{prefix} Are we speaking with #{Current.party.name}?"

    render xml: VoiceXML.new(
      message: message,
      next_path: voice_session_verifications_path,
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
        Current.party.id,
        prefix: "Sorry, I didn't understand you."
      )
    end
  end

  private

  def process_verification
    if Current.party.passed_submission_deadline?
      session.delete(:current_party_id)

      render xml: VoiceXML.new(
        message: translate(".passed_submission_deadline")
      )
    else
      redirect_to new_voice_party_response_path(venue: "patterson_park")
    end
  end
end
