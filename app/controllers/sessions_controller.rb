class SessionsController < ApplicationController
  def new
  end

  def create
    # filter out reservation code from logs
    party = Party.find_by(reservation_code: params[:session][:reservation_code])

    if party
      session[:current_party_id] = party.id
      redirect_to introduction_path
    else
      render :new
    end
  end
end
