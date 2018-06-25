require "test_helper"

class VoicePartyResponsesTest < ActionDispatch::IntegrationTest
  test "a party submits their responses" do
    party = Party.create!(
      family_name: "Banks",
      reservation_code: 232425,
      responses_end_at: 1.week.from_now
    )

    party.guests.create!(first_name: "Philip", primary: true)
    party.guests.create!(first_name: "Vivian", primary: true)
    party.guests.create!(first_name: "Carlton")

    get voice_introduction_path

    assert_match(
      /english_intro.*.mp3/,
      xml_response.Response.Play.content
    )

    follow_redirect

    assert_match(
      /enter your.*reservation code/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path params: { "Digits" => party.reservation_code }

    assert_includes(
      xml_response.Response.Gather.Say.content,
      "Am I speaking with Philip or Vivian Banks?"
    )

    post_to_next_path params: { "SpeechResult" => "Yes.", "Confidence" => ".9" }

    assert_match(
      /everyone.*attending.*Patterson Park/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path params: { "SpeechResult" => "No.", "Confidence" => ".9" }

    assert_match(
      /Will Philip be attending.*ceremony and picnic/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path params: { "SpeechResult" => "Yes.", "Confidence" => ".9" }

    assert_match(
      /Will Vivian be attending.*ceremony and picnic/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path params: { "SpeechResult" => "Yes.", "Confidence" => ".9" }

    assert_match(
      /Will Carlton be attending.*ceremony and picnic/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path params: { "SpeechResult" => "No.", "Confidence" => ".9" }

    assert_match(
      /go over.*Is this correct/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path params: { "SpeechResult" => "Yes.", "Confidence" => ".9" }

    assert_match(
      /everyone.*attending.*Douglass-Myers/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path(
      params: { "SpeechResult" => "Yes.", "Confidence" => ".9" },
      follow_redirect: false
    )

    assert_match(
      /Thanks.*!/,
      xml_response.Response.Say.content
    )
  end

  test "a party of one submits their responses" do
    party = Party.create!(
      reservation_code: 424344,
      responses_end_at: 1.week.from_now
    )

    party.guests.create!(first_name: "Will", last_name: "Smith", primary: true)

    get voice_introduction_path

    assert_match(
      /english_intro.*.mp3/,
      xml_response.Response.Play.content
    )

    follow_redirect

    assert_match(
      /enter your.*reservation code/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path params: { "Digits" => party.reservation_code }

    assert_includes(
      xml_response.Response.Gather.Say.content,
      "Am I speaking with Will Smith?"
    )

    post_to_next_path params: { "SpeechResult" => "Yes.", "Confidence" => ".9" }

    assert_match(
      /you.*attending.*Patterson Park/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path params: { "SpeechResult" => "No.", "Confidence" => ".9" }

    assert_match(
      /you.*attending.*Douglass-Myers/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path(
      params: { "SpeechResult" => "Yes.", "Confidence" => ".9" },
      follow_redirect: false
    )

    assert_match(
      /Thanks.*!/,
      xml_response.Response.Say.content
    )
  end

  test "a party tries to submit responses after their end date" do
    party = Party.create!(
      reservation_code: 987654,
      responses_end_at: 1.week.ago
    )

    party.guests.create!(first_name: "Will", last_name: "Smith", primary: true)

    get new_voice_session_path

    assert_match(
      /enter your.*reservation code/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path params: { "Digits" => party.reservation_code }

    assert_includes(
      xml_response.Response.Gather.Say.content,
      "Am I speaking with Will Smith?"
    )

    post_to_next_path(
      params: { "SpeechResult" => "Yes.", "Confidence" => ".9" },
      follow_redirect: false
    )

    assert_match(
      /Sorry/,
      xml_response.Response.Say.content
    )
  end

  test "a party tries to submit responses with an invalid reservation code" do
    party = Party.create!(
      reservation_code: 536631,
      responses_end_at: 1.week.from_now
    )

    party.guests.create!(first_name: "Will", last_name: "Smith", primary: true)

    get voice_introduction_path

    assert_match(
      /english_intro.*.mp3/,
      xml_response.Response.Play.content
    )

    follow_redirect

    assert_match(
      /enter your.*reservation code/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path params: { "Digits" => "very wrong" }

    assert_match(
      /Sorry.*say or enter.*reservation code/,
      xml_response.Response.Gather.Say.content
    )
  end

  def follow_redirect
    get xml_response.Response.Redirect.content
  end

  def post_to_next_path(options = {})
    follow_redirect = options.delete(:follow_redirect) { true }
    post xml_response.Response.Gather["action"], options
    follow_redirect! if follow_redirect
  end

  def xml_response
    Nokogiri::Slop(response.parsed_body)
  end
end
