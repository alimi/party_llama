class Voice::SessionVerificationsController < Voice::ApplicationController
  include Voiceable
  include PartyAuthentication

  def new
    message = translate(
      ".message",
      party: Current.party.greeting(conjunction: translate("or")),
      prefix: params[:prefix]
    )

    render xml: VoiceXML.new(
      message: message,
      next_path: voice_session_verifications_path,
      expect: expected_input
    )
  end

  def create
    if voice_input.affirmative?
      process_verification
    elsif voice_input.negative?
      redirect_to new_voice_session_path(prefix: translate(".wrong_party"))
    else
      redirect_to new_voice_session_verification_path(
        prefix: translate("voice.unclear_yes_no")
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

  def expected_input
    AffirmativeAndNegativeWords.to_s
  end
end
