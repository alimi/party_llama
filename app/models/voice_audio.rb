class VoiceAudio
  attr_reader :source_url, :next_path

  def initialize(source_url:, next_path:)
    @source_url = source_url
    @next_path = next_path
  end

  def to_xml(options = {})
    response = Twilio::TwiML::VoiceResponse.new
    response.play(url: source_url)
    response.redirect(next_path, method: "GET")
    response.to_s
  end
end
