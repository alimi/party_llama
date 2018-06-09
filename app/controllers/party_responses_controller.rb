class PartyResponsesController < ApplicationController
  include PartyAuthentication
  include ResponseEligibilityFilter

  def index
    @patterson_park_guests = Guests.new(
      *Current.party.guests.partition(&:attending_patterson_park)
    )

    @douglass_myers_guests = Guests.new(
      *Current.party.guests.partition(&:attending_douglass_myers)
    )
  end

  Guests = Struct.new(:attending, :not_attending)
end
