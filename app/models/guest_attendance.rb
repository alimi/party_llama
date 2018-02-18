module GuestAttendance
  class UnknownEventField < StandardError; end

  def self.update(party:, event_field:, attending_guest_ids:)
    raise UnknownEventField unless event_fields.include?(event_field)

    party.guests.update_all(event_field => false)
    party.guests.where(id: attending_guest_ids).update_all(event_field => true)
  end

  def self.event_fields
    [:attending_douglass_myers, :attending_patterson_park]
  end
end
