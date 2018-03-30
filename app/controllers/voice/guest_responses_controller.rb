class Voice::GuestResponsesController < Voice::ApplicationController
  include Venueable
  include PartyAuthentication

  def new
    guest = current_guest || next_guest

    message = venue_translation("message", prefix: params[:prefix], name: guest.first_name)

    render xml: VoiceXML.new(
      message: message,
      next_path: venue_path(:voice_guest_responses_path, guest_id: guest.id)
    )
  end

  def create
    input = VoiceInput.new(voice_params)

    if input.affirmative? || input.negative?
      update_guest_attendance(input)
    else
      redirect_to venue_path(
        :new_voice_guest_response_path,
        prefix: "Sorry, I didn't understand you.",
        guest_id: current_guest.id
      )
    end
  end

  private

  def update_guest_attendance(input)
    current_guest.update!(venue_attendance_field => input.affirmative?)

    if next_guest.present?
      redirect_to venue_path(
        :new_voice_guest_response_path,
        guest_id: next_guest.id
      )
    else
      complete_venue_responses
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

  def voice_params
    params.slice("Digits", "SpeechResult", "Confidence").permit!
  end
end
