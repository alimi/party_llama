class VoiceMessage
  attr_reader :message, :next_path

  def initialize(message:, next_path:)
    @message = message
    @next_path = next_path
  end

  def to_xml(options = {})
    response = Twilio::TwiML::VoiceResponse.new
    response.say(message, voice: "alice", language: language)
    response.record(timeout: 10, action: next_path)
    response.hangup
    response.to_s
  end

  private

  def language
    if I18n.locale == :es
      "es-ES"
    else
      "en-US"
    end
  end
end
