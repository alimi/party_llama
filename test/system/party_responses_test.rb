require "application_system_test_case"

class PartyResponsesTest < ApplicationSystemTestCase
  setup do
    @party = Party.create!(
      family_name: "Banks",
      reservation_code: 232425,
      responses_end_at: 1.week.from_now
    )
  end

  test "a party submits their responses" do
    @party.guests.create!(first_name: "Philip", primary: true)
    @party.guests.create!(first_name: "Vivian", primary: true)
    @party.guests.create!(first_name: "Carlton")

    visit root_path
    fill_in "session_reservation_code", with: "23 24 25"
    click_button "Submit"

    assert page.has_content?("Welcome Philip and Vivian Banks!")
    click_button "Next"

    assert page.has_content?("Patterson Park")
    check "Philip Banks"
    check "Carlton Banks"
    click_button "Next"

    assert page.has_content?("Fredrick Douglass-Isaac Myers")
    check "Philip Banks"
    check "Vivian Banks"
    click_button "Next"

    assert page.has_content?(/Review/)
    assert(
      find("h2", text: /Patterson Park/).
      sibling("p", text: "✅ Philip Banks").
      sibling("p", text: "✅ Carlton Banks").
      sibling("p", text: "❌ Vivian Banks")
    )
    assert(
      find("h2", text: /Fredrick Douglass-Isaac Myers/).
      sibling("p", text: "✅ Philip Banks").
      sibling("p", text: "✅ Vivian Banks").
      sibling("p", text: "❌ Carlton Banks")
    )
    click_button "Submit"

    assert page.has_content?(/Thanks/)
  end

  test "a party enters an invalid reservation code" do
    visit root_path
    fill_in "session_reservation_code", with: "something wrong"
    click_button "Submit"

    assert page.has_content?("Sorry")
  end

  test "a party tries to submit responses after the response end date" do
    @party.update!(responses_end_at: 1.day.ago)

    visit root_path
    fill_in "session_reservation_code", with: @party.reservation_code
    click_button "Submit"

    assert page.has_content?("Thanks"), "The party is sent to the conclusion."
  end
end
