class Voice::GuestResponsesController < Voice::ApplicationController
  include Voiceable
  include Venueable
  include PartyAuthentication

  def new
    guest = current_guest || next_guest

    message = venue_translation("message", prefix: params[:prefix], name: guest.first_name)

    render xml: VoiceXML.new(
      message: message,
      next_path: venue_path(:voice_guest_responses_path, guest_id: guest.id),
      expect: AffirmativeAndNegativeWords.to_s
    )
  end

  def create
    if voice_input.affirmative? || voice_input.negative?
      update_guest_attendance
    else
      redirect_to venue_path(
        :new_voice_guest_response_path,
        prefix: "Sorry, I didn't understand you.",
        guest_id: current_guest.id
      )
    end
  end

  private

  def update_guest_attendance
    current_guest.update!(venue_attendance_field => voice_input.affirmative?)

    if next_guest.present?
      redirect_to venue_path(
        :new_voice_guest_response_path,
        guest_id: next_guest.id
      )
    else
      redirect_to venue_path(
        :new_voice_guest_response_confirmation_path,
        party: Current.party
      )
    end
  end

  def next_guest
    return @next_guest if defined? @next_guest

    if current_guest.present?
      @next_guest = Current.party.guests.where("id > ?", current_guest.id).order(:id).first
    else
      @next_guest = Current.party.guests.order(:id).first
    end
  end

  def current_guest
    @current_guest ||= Current.party.guests.find_by(id: params[:guest_id])
  end
end
