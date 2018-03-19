class Voice::VerificationsController < Voice::ApplicationController
  def create
    render xml: VoiceXML.new(message: "Adios!")
  end
end
