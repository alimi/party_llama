class Voice::GuestResponseConfirmationsController < Voice::ApplicationController
  include Voiceable
  include Venueable
  include PartyAuthentication

  def new
    attending_guests, not_attending_guests =
      Current.party.guests.partition { |guest| guest[venue_attendance_field] }

    message = [
      params[:prefix],
      venue_translation("intro"),
      translate(
        ".attending",
        guests: attending_guests.map(&:first_name).to_sentence,
        count: attending_guests.length
      ),
      translate(
        ".not_attending",
        guests: not_attending_guests.map(&:first_name).to_sentence,
        count: not_attending_guests.length
      ),
      translate(".concluscion")
    ].join(" ")

    render xml: VoiceXML.new(
      message: message,
      next_path: venue_path(:voice_guest_response_confirmations_path),
      expect: AffirmativeAndNegativeWords.to_s
    )
  end

  def create
    if voice_input.affirmative?
      complete_venue_responses
    elsif voice_input.negative?
      redirect_to venue_path(
        :new_voice_guest_response_path,
        prefix: translate(".error")
      )
    else
      redirect_to venue_path(
        :new_voice_guest_response_confirmation_path,
        prefix: translate("voice.unclear_yes_no")
      )
    end
  end
end
