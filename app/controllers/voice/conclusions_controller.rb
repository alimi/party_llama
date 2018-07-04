class Voice::ConclusionsController < Voice::ApplicationController
  include Voiceable
  include PartyAuthentication

  def new
    prefix = params[:prefix] || attendance_message

    render xml: VoiceXML.new(
      message: translate(".message", prefix: prefix),
      next_path: voice_conclusions_path,
      expect: expected_input
    )
  end

  def create
    if voice_input.affirmative?
      redirect_to new_voice_message_path
    elsif voice_input.negative?
      render xml: VoiceXML.new(message: translate(".good_bye"))
    else
      redirect_to new_voice_conclusion_path(
        prefix: translate("voice.unclear_yes_no")
      )
    end
  end

  private

  def expected_input
    AffirmativeAndNegativeWords.to_s
  end

  def attendance_message
    if Current.party.attending?
      translate(".attending")
    else
      translate(".not_attending")
    end
  end
end
