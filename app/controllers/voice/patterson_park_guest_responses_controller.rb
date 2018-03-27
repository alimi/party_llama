class Voice::PattersonParkGuestResponsesController < Voice::ApplicationController
  def new
    guest = current_guest || next_guest

    message = "#{params[:prefix]} Will #{guest.first_name} be attending the picnic and ceremony in Patterson Park?"

    render xml: VoiceXML.new(
      message: message,
      next_path:  voice_patterson_park_guest_responses_path(guest_id: guest.id)
    )
  end

  def create
    input = VoiceInput.new(voice_params)

    if input.affirmative? || input.negative?
      update_guest_attendance(input)
    else
      redirect_to new_voice_patterson_park_guest_response_path(
        prefix: "Sorry, I didn't understand you.",
        guest_id: current_guest.id
      )
    end
  end

  private

  def update_guest_attendance(input)
    current_guest.update!(attending_patterson_park: input.affirmative?)

    if next_guest.present?
      redirect_to new_voice_patterson_park_guest_response_path(
        guest_id: next_guest.id
      )
    else
      render xml: VoiceXML.new(message: "Yay! Smell you later!")
    end
  end

  def next_guest
    return @next_guest if defined? @next_guest

    if current_guest.present?
      @next_guest = party.guests.where("id > ?", current_guest.id).order(:id).first
    else
      @next_guest = party.guests.order(:id).first
    end
  end

  def current_guest
    @current_guest ||= party.guests.find_by(id: params[:guest_id])
  end

  def party
    @party ||= Party.find(session[:current_party_id])
  end

  def voice_params
    params.slice("Digits", "SpeechResult", "Confidence").permit!
  end
end
