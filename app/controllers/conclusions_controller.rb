class ConclusionsController < ApplicationController
  include PartyAuthentication

  def show
    @attending = Current.party.guests.any? do |guest|
      guest.attending_patterson_park? || guest.attending_douglass_myers?
    end

    remove_current_party_from_session
  end

  private

  def remove_current_party_from_session
    session.delete(:current_party_id)
    Current.party = nil
  end
end
