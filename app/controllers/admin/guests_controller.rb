class Admin::GuestsController < ApplicationController
  include AdminAuthentication

  before_action :set_party, except: :index

  def index
    @party = Party.includes(:guests).find(params[:party_id])
  end

  def new
  end

  def create
    @party.guests.create!(guest_params)
    redirect_to admin_party_guests_path(@party)
  end

  private

  def guest_params
    params.require(:guest).permit(:first_name, :last_name)
  end

  def set_party
    @party = Party.find(params[:party_id])
  end
end
