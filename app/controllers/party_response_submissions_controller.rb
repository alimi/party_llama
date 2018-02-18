class PartyResponseSubmissionsController < ApplicationController
  include PartyAuthentication

  def create
    Current.party.update!(responses_submitted_at: DateTime.current)
    redirect_to conclusion_path
  end
end
