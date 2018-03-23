class Voice::PattersonParkResponsesController < Voice::ApplicationController
  def create
    input = VoiceInput.new(voice_params)

    if input.affirmative?
      render xml: VoiceXML.new(message: "Yay! Smell you later!")
    elsif input.negative?
      render xml: VoiceXML.new(message: "Boo. You stinky.")
    else
      render xml: VoiceXML.new(
        next_path: voice_party_patterson_park_responses_path(party),
        message: "Sorry, I didn't understand you. Will everyone be attending the ceremony and picnic in Patterson Park?"
      )
    end
  end

  private

  def voice_params
    params.slice("Digits", "SpeechResult", "Confidence").permit!
  end
end
