module Venueable
  def venue_translation(key, options = {})
    path = controller_path.tr('/', '.')
    translate("#{path}.#{params[:action]}.#{params[:venue]}.#{key}", options)
  end

  def venue_attendance_field
    "attending_#{params[:venue]}"
  end

  def complete_venue_responses
    if params[:venue] == "patterson_park"
      redirect_to new_voice_party_response_path(venue: "douglass_myers")
    else
      Current.party.update!(responses_submitted_at: DateTime.current)
      render xml: VoiceXML.new(message: concluscion)
    end
  end

  def venue_path(path, options = {})
    public_send(path, options.merge(venue: params[:venue]))
  end

  private

  def concluscion
    "#{translate("voice.concluscion.prefix")} #{attendance_message}"
  end

  def attendance_message
    if Current.party.attending?
      translate("voice.concluscion.attending")
    else
      translate("voice.concluscion.not_attending")
    end
  end
end
