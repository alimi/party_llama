require "test_helper"

class GuestAttendanceTest < ActiveSupport::TestCase
  setup do
    @party = Party.create!

    @guest_one = @party.guests.create!(
      first_name: "T'challa",
      attending_patterson_park: true
    )

    @guest_two = @party.guests.create!(
      first_name: "Shuri",
      attending_patterson_park: false
    )
  end

  test "::update" do
    GuestAttendance.update(
      party: @party,
      event_field: :attending_patterson_park,
      attending_guest_ids: [@guest_two.id]
    )

    assert_equal true, @guest_two.reload.attending_patterson_park?,
      "It marks attending guests as attending"

    assert_equal false, @guest_one.reload.attending_patterson_park?,
      "It marks non-attending guests as not attending"
  end

  test "::update when attending_guest_ids is empty" do
    GuestAttendance.update(
      party: @party,
      event_field: :attending_patterson_park,
      attending_guest_ids: []
    )

    assert_equal false, [@guest_one, @guest_two].
      all? { |guest| guest.reload.attending_patterson_park? },
      "It marks all guests as not attending"
  end

  test "::update with an unknown event_field" do
    assert_raises(GuestAttendance::UnknownEventField) do
      GuestAttendance.update(
        party: @party,
        event_field: :something_bogus,
        attending_guest_ids: []
      )
    end
  end
end
