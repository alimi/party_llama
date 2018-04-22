class Voice::GuestResponseConfirmationsController < Voice::ApplicationController
  include Voiceable
  include Venueable
  include PartyAuthentication

  def new
    attending_guests, not_attending_guests =
      Current.party.guests.partition { |guest| guest[venue_attendance_field] }

    message = "#{venue_translation(".prefix")} #{translate(
      ".message",
      attending_guests: guest_sentence(attending_guests),
      not_attending_guests: guest_sentence(not_attending_guests)
    )}"

    render xml: VoiceXML.new(
      message: message,
      next_path: venue_path(:voice_guest_response_confirmations_path),
      expect: AffirmativeAndNegativeWords.to_s
    )
  end

  def create
    if voice_input.affirmative?
      complete_venue_responses
    else
      redirect_to venue_path(
        :new_voice_guest_response_path,
        prefix: "Sorry about that. Let's try again."
      )
    end
  end

  private

  def guest_sentence(guests)
    guests.map(&:first_name).to_sentence.presence || "no one"
  end
end
