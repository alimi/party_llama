class DouglassMyersResponsesController < ApplicationController
  include PartyAuthentication

  def new
    @guests = Current.party.guests
  end

  def create
    attending_guests = Current.party.guests.where(
      id: params[:douglass_myers_response][:attending_guest_ids]
    )

    attending_guests.update_all(attending_douglass_myers: true)

    redirect_to party_responses_path
  end
end
