class PartyResponseSubmissionsController < ApplicationController
  def create
    current_party.update!(responses_submitted_at: DateTime.current)
    redirect_to conclusion_path
  end
end
