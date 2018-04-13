class Voice::PartyResponsesController < Voice::ApplicationController
  include Voiceable
  include Venueable
  include PartyAuthentication

  def new
    prefix = params[:prefix] || venue_translation(
      "intro",
      guests: Current.party.guests.map(&:first_name).to_sentence
    )

    render xml: VoiceXML.new(
      message: venue_translation("message", prefix: prefix),
      next_path: venue_path(:voice_party_responses_path)
    )
  end

  def create
    if voice_input.affirmative?
      Current.party.guests.update_all(venue_attendance_field => true)
      complete_venue_responses
    elsif voice_input.negative?
      redirect_to venue_path(
        :new_voice_guest_response_path,
        prefix: "Ok, no worries. We'll confirm everyone individually."
      )
    else
      redirect_to venue_path(
        :new_voice_party_response_path,
        prefix: "Sorry, I didn't understand you."
      )
    end
  end
end