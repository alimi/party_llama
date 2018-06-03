class SessionsController < ApplicationController
  def new
  end

  def create
    Current.party = Party.find_by(
      reservation_code: params[:session][:reservation_code].delete(" ")
    )

    if Current.party
      save_current_party_in_session
    else
      flash[:error] = "Sorry, we couldn't find your reservation. Please try again."
      redirect_to new_session_path
    end
  end

  private

  def save_current_party_in_session
    session[:current_party_id] = Current.party.id

    if Current.party.passed_submission_deadline?
      redirect_to conclusion_path
    else
      redirect_to introduction_path
    end
  end
end
