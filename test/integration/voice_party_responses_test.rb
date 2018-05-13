require "test_helper"

class VoicePartyResponsesTest < ActionDispatch::IntegrationTest
  test "a party submits their responses" do
    party = Party.create!(
      name: "The Avengers",
      reservation_code: "232425",
      responses_end_at: 1.week.from_now
    )

    party.guests.create!(first_name: "Black", last_name: "Panther")
    party.guests.create!(first_name: "Iron", last_name: "Man")
    party.guests.create!(first_name: "Captain", last_name: "America")

    get new_voice_session_path

    assert_match(
      /enter your.*reservation code/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path params: { "Digits" => party.reservation_code }

    assert_includes(
      xml_response.Response.Gather.Say.content,
      "Are we speaking with The Avengers?"
    )

    post_to_next_path params: { "SpeechResult" => "Yes.", "Confidence" => ".9" }

    assert_match(
      /everyone.*attending.*Patterson Park/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path params: { "SpeechResult" => "No.", "Confidence" => ".9" }

    assert_match(
      /Will Black be attending.*ceremony and picnic/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path params: { "SpeechResult" => "Yes.", "Confidence" => ".9" }

    assert_match(
      /Will Iron be attending.*ceremony and picnic/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path params: { "SpeechResult" => "Yes.", "Confidence" => ".9" }

    assert_match(
      /Will Captain be attending.*ceremony and picnic/,
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
      reservation_code: "424344",
      responses_end_at: 1.week.from_now
    )

    party.guests.create!(first_name: "Peter", last_name: "Parker")

    get new_voice_session_path

    assert_match(
      /enter your.*reservation code/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path params: { "Digits" => party.reservation_code }

    assert_includes(
      xml_response.Response.Gather.Say.content,
      "Are we speaking with Peter Parker?"
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
      name: "Justice League",
      reservation_code: "987654",
      responses_end_at: 1.week.ago
    )

    get new_voice_session_path

    assert_match(
      /enter your.*reservation code/,
      xml_response.Response.Gather.Say.content
    )

    post_to_next_path params: { "Digits" => party.reservation_code }

    assert_includes(
      xml_response.Response.Gather.Say.content,
      "Are we speaking with Justice League?"
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
      name: "Justice League",
      reservation_code: "536631",
      responses_end_at: 1.week.from_now
    )

    get new_voice_session_path

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

  def post_to_next_path(options = {})
    follow_redirect = options.delete(:follow_redirect) { true }
    post xml_response.Response.Gather["action"], options
    follow_redirect! if follow_redirect
  end

  def xml_response
    Nokogiri::Slop(response.parsed_body)
  end
end
