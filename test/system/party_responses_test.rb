require "application_system_test_case"

class PartyResponsesTest < ApplicationSystemTestCase
  test "a party responds to their invitation" do
    party = Party.create!(name: "The Avengers", reservation_code: "232425")

    visit new_party_response_path
    fill_in "Reservation code", with: party.reservation_code
    click_button "Submit"

    assert page.has_content?("Summary")
  end
end
