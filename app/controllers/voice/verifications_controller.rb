class Voice::VerificationsController < Voice::ApplicationController
  def create
    input = VoiceInput.new(voice_params)

    if input.affirmative?
      render xml: VoiceXML.new(
        next_path: voice_party_patterson_park_responses_path(party),
        message: introductory_message
      )
    elsif input.negative?
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

  def introductory_message
    <<~MESSAGE
      Yay! We're excited to hear from you!
      There's a lot of info about the wedding. Ceremony, picnic, dancing, blah, blah, blah.
      Give me one minute while I look up your invitations for the ceremony and picnic in Patterson Park.
      I found invitations for #{party.guests.map(&:first_name).to_sentence}. Will everyone be attending the ceremony and picnic in Patterson Park?
    MESSAGE
  end

  def party
    @party ||= Party.find(params[:session_id])
  end
end
