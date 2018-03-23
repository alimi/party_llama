class Voice::PattersonParkResponsesController < Voice::ApplicationController
  def new
    prefix = params[:prefix] || intro
    message = "#{prefix} Will everyone be attending the ceremony and picnic in Patterson Park?"

    render xml: VoiceXML.new(
      message: message,
      next_path: voice_patterson_park_responses_path
    )
  end

  def create
    input = VoiceInput.new(voice_params)

    if input.affirmative?
      render xml: VoiceXML.new(message: "Yay! Smell you later!")
    elsif input.negative?
      render xml: VoiceXML.new(message: "Boo. You stinky.")
    else
      redirect_to new_voice_patterson_park_responses_path(
        prefix: "Sorry, I didn't understand you."
      )
    end
  end

  private

  def voice_params
    params.slice("Digits", "SpeechResult", "Confidence").permit!
  end

  def intro
    <<~INTRO
      Yay! We're excited to hear from you!
      There's a lot of info about the wedding. Ceremony, picnic, dancing, blah, blah, blah.
      Give me one minute while I look up your invitations for the ceremony and picnic in Patterson Park.
      I found invitations for #{party.guests.map(&:first_name).to_sentence}.
    INTRO
  end

  def party
    @party ||= Party.find(session[:current_party_id])
  end
end
