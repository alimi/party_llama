class VoiceXML
  attr_reader :message, :next_path, :expect

  def initialize(message:, next_path: nil, expect: nil)
    @message = message
    @next_path = next_path
    @expect = expect || ""
  end

  def to_xml(options = {})
    if next_path.present?
      continuing_xml
    else
      finishing_xml
    end
  end

  private

  def continuing_xml
    response = Twilio::TwiML::VoiceResponse.new do |response|
      response.gather(
        action: next_path,
        input: "dtmf speech",
        hints: expect,
        language: language,
        timeout: 3
      )do |gather|
        gather.say message, say_options
      end
    end

    response.to_s
  end

  def finishing_xml
    response = Twilio::TwiML::VoiceResponse.new do |response|
      response.say message, say_options
      response.hangup
    end

    response.to_s
  end

  def say_options
    { voice: "alice", language: language }
  end

  def language
    if I18n.locale == :es
      "es-ES"
    else
      "en-US"
    end
  end
end
