class Voice::PartyResponsesController < Voice::ApplicationController
  include Voiceable
  include Venueable
  include PartyAuthentication

  def new
    prefix = params[:prefix] || venue_translation(
      "intro",
      guests: Current.party.guests.map(&:first_name).to_sentence
    )

    message = venue_translation(
      "message",
      prefix: prefix,
      count: Current.party.guests.length
    )

    render xml: VoiceXML.new(
      message: message,
      next_path: venue_path(:voice_party_responses_path),
      expect: AffirmativeAndNegativeWords.to_s
    )
  end

  def create
    if voice_input.affirmative?
      Current.party.guests.update_all(venue_attendance_field => true)
      complete_venue_responses
    elsif voice_input.negative?
      process_negative_input
    else
      redirect_to venue_path(
        :new_voice_party_response_path,
        prefix: translate("voice.unclear_speech")
      )
    end
  end

  private

  def process_negative_input
    if Current.party.single?
      Current.party.guests.update_all(venue_attendance_field => false)
      complete_venue_responses
    else
      redirect_to venue_path(
        :new_voice_guest_response_path,
        prefix: translate(".transition")
      )
    end
  end
end
