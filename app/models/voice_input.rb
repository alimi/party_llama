class VoiceInput
  attr_reader :digits, :speech

  def initialize(input = {})
    @digits = input["Digits"]

    @speech = SpeechInput.new(
      input["SpeechResult"],
      input["Confidence"],
      input["expecting"]
    )
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
    speech.to_s || digits.to_s
  end

  SpeechInput = Struct.new(:speech, :confidence, :expecting) do
    def initialize(speech, confidence, expecting)
      super(
        (speech || "").downcase.tr("().", "").tr(" ", ""),
        confidence.to_f,
        (expecting || "").downcase
      )
    end

    def to_s
      confidence_result || expecting_result
    end

    def confidence_result
      if confidence > 0.7
        speech
      else
        nil
      end
    end

    def expecting_result
      if expecting.include?(speech)
        speech.presence
      else
        nil
      end
    end
  end
end
