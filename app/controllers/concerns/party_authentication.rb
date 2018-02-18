module PartyAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  def authenticate
    if party = Party.find_by(id: session[:current_party_id])
      Current.party = party
    else
      redirect_to new_session_path
    end
  end
end
