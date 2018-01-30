require "application_system_test_case"

class PartyResponsesTest < ApplicationSystemTestCase
  setup do
    @party = Party.create!(
      name: "The Avengers",
      reservation_code: "232425",
      responses_end_at: 1.week.from_now
    )
  end

  test "a party submits their responses" do
    @party.guests.create!(first_name: "Black", last_name: "Panther")
    @party.guests.create!(first_name: "Iron", last_name: "Man")
    @party.guests.create!(first_name: "Captain", last_name: "America")

    visit root_path
    fill_in "Reservation code", with: @party.reservation_code
    click_button "Submit"

    assert page.has_content?("Welcome")
    click_link "Next"

    assert page.has_content?("Patterson Park")
    check "Black Panther"
    check "Captain America"
    click_button "Next"

    assert page.has_content?("Douglass-Myers")
    check "Black Panther"
    check "Iron Man"
    click_button "Next"

    assert page.has_content?("Review")
    assert page.has_content?(
      "Patterson Park 2 guests attending: Black Panther and Captain America"
    )
    assert page.has_content?(
      "Douglass-Myers 2 guests attending: Black Panther and Iron Man"
    )
    click_button "Submit Responses"

    assert page.has_content?("Yay")
  end

  test "a party enters an invalid reservation code" do
    visit root_path
    fill_in "Reservation code", with: "something wrong"
    click_button "Submit"

    assert page.has_content?("Sorry")
  end

  test "a party tries to submit responses after the response end date" do
    @party.update!(responses_end_at: 1.day.ago)

    visit root_path
    fill_in "Reservation code", with: @party.reservation_code
    click_button "Submit"

    assert page.has_content?("Yay")
  end
end
