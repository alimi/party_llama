class ConclusionsController < ApplicationController
  include PartyAuthentication

  def show
    remove_current_party_from_session
  end

  private

  def remove_current_party_from_session
    session.delete(:current_party_id)
    Current.party = nil
  end
end
