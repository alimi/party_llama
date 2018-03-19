class Voice::VerificationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    render xml: VoiceXML.new(message: "Adios!")
  end
end
