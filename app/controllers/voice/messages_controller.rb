class Voice::MessagesController < Voice::ApplicationController
  include Voiceable
  include PartyAuthentication

  def new
    render xml: VoiceMessage.new(
      message: t(".message"),
      next_path: voice_messages_path
    )
  end

  def create
    Current.party.messages << params["RecordingUrl"]
    Current.party.save!
    render xml: EmptyVoiceXML.new
  end
end
