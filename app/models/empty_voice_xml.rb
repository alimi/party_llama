class EmptyVoiceXML
  def to_xml(options = {})
    Twilio::TwiML::VoiceResponse.new.to_s
  end
end
