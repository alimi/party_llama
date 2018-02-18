class SessionsController < ApplicationController
  def new
  end

  def create
    party = Party.find_by(reservation_code: params[:session][:reservation_code])

    if party
      session[:current_party_id] = party.id

      if party.passed_submission_deadline?
        redirect_to conclusion_path
      else
        redirect_to introduction_path
      end
    else
      flash[:error] = "Sorry, we couldn't find your reservation. Please try again."
      redirect_to new_session_path
    end
  end
end
