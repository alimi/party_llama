class DouglassMyersResponsesController < ApplicationController
  include PartyAuthentication
  include ResponseEligibilityFilter

  def new
    @guests = Current.party.guests
  end

  def create
    GuestAttendance.update(
      party: Current.party,
      event_field: :attending_douglass_myers,
      attending_guest_ids: params[:douglass_myers_response][:attending_guest_ids]
    )

    redirect_to party_responses_path
  end
end
