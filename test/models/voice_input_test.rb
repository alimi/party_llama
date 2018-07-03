require "test_helper"

class VoiceInputTest < ActiveSupport::TestCase
  test "#to_s when confidence is less than 0.7 and expected speech is given" do
    voice_input = VoiceInput.new(
      "SpeechResult" => "Yes.",
      "Confidence" => "0.0",
      "expecting" => "yes,no"
    )

    assert_equal "yes", voice_input.to_s
  end

  test "#to_s when confidence is less than 0.7 and expected speech is not given" do
    voice_input = VoiceInput.new(
      "SpeechResult" => "Yes.",
      "Confidence" => "0.0"
    )

    assert_equal "", voice_input.to_s
  end

  test "#to_s when confidence is greater than 0.7" do
    voice_input = VoiceInput.new(
      "SpeechResult" => "Yes.",
      "Confidence" => "0.8"
    )

    assert_equal "yes", voice_input.to_s
  end

  test "#to_s when there are digits instead of speech" do
    voice_input = VoiceInput.new(
      "Digits" => "42"
    )

    assert_equal "42", voice_input.to_s
  end
end
