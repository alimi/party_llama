class PattersonParkResponsesController < ApplicationController
  include PartyAuthentication
  include ResponseEligibilityFilter

  def new
    @guests = Current.party.guests
  end

  def create
    attending_guests = Current.party.guests.where(
      id: params[:patterson_park_response][:attending_guest_ids]
    )

    attending_guests.update_all(attending_patterson_park: true)

    redirect_to new_douglass_myers_responses_path
  end
end
