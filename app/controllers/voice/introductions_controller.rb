class Voice::IntroductionsController < Voice::ApplicationController
  def show
    render xml: VoiceAudio.new(
      source_url: ActionController::Base.helpers.asset_url(audio_filename),
      next_path: new_voice_session_path
    )
  end

  private

  def audio_filename
    if I18n.locale == :es
      "spanish_intro.mp3"
    else
      "english_intro.mp3"
    end
  end
end
