class VoiceInput
  attr_reader :digits, :speech

  def initialize(input = {})
    @digits = input["Digits"]
    @speech = SpeechInput.new(input["SpeechResult"], input["Confidence"])
  end

  def affirmative?
    options = I18n.translate(:affirmative_words) + ["1"]
    options.include?(to_s)
  end

  def negative?
    options = I18n.translate(:negative_words) + ["2"]
    options.include?(to_s)
  end

  def to_s
    speech.to_s || digits
  end

  SpeechInput = Struct.new(:speech, :confidence) do
    def to_s
      if confidence.to_f > 0.7
        speech.tr("().", "").downcase
      else
        nil
      end
    end
  end
end
