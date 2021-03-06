module Voiceable
  def voice_input
    @voice_input ||= VoiceInput.new(voice_params)
  end

  private

  def voice_params
    params.
      slice("Digits", "SpeechResult", "Confidence").
      permit!.
      merge(expecting: expected_input)
  end

  def expected_input
    ""
  end
end
