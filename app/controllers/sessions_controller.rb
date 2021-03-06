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
      flash[:error] = translate(".party_not_found")
      redirect_to root_path
    end
  end

  def destroy
    session.delete(:current_party_id)
    Current.party = nil
    redirect_to root_path
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
