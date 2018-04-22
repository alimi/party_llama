class VoiceInput
  attr_reader :digits, :speech

  def initialize(input = {})
    @digits = input["Digits"]
    @speech = SpeechInput.new(input["SpeechResult"], input["Confidence"])
  end

  def affirmative?
    ["Yes.", "1"].include?(to_s)
  end

  def negative?
    ["No.", "2"].include?(to_s)
  end

  def to_s
    speech.to_s || digits
  end

  SpeechInput = Struct.new(:speech, :confidence) do
    def to_s
      if confidence.to_f > 0.7
        speech
      else
        nil
      end
    end
  end
end
