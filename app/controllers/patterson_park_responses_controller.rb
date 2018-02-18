class PattersonParkResponsesController < ApplicationController
  include PartyAuthentication
  include ResponseEligibilityFilter

  def new
    @guests = Current.party.guests
  end

  def create
    GuestAttendance.update(
      party: Current.party,
      event_field: :attending_patterson_park,
      attending_guest_ids: params[:patterson_park_response][:attending_guest_ids]
    )

    redirect_to new_douglass_myers_responses_path
  end
end
