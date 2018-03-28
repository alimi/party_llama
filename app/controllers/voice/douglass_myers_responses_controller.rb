class Voice::DouglassMyersResponsesController < Voice::ApplicationController
  def new
    prefix = params[:prefix] || intro
    message = "#{prefix} Will everyone be attending the cake reception at the Douglass-Myers Maritime Park?"

    render xml: VoiceXML.new(
      message: message,
      next_path: voice_douglass_myers_responses_path
    )
  end

  def create
    input = VoiceInput.new(voice_params)

    if input.affirmative?
      party.guests.update_all(attending_douglass_myers: true)
      render xml: VoiceXML.new(message: "Yay! Smell you later!")
    elsif input.negative?
      redirect_to new_voice_douglass_myers_guest_response_path(
        prefix: "Ok, no worries. We'll confirm everyone individually."
      )
    else
      redirect_to new_voice_douglass_myers_response_path
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
      Great! Now, we'll move on to the cake reception at the Douglass-Myers Maritime Park.
    INTRO
  end

  def party
    @party ||= Party.find(session[:current_party_id])
  end
end
