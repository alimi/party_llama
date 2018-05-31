class Admin::GuestsController < ApplicationController
  include AdminAuthentication

  before_action :set_party

  def new
    @guest = @party.guests.new
  end

  def create
    @party.guests.create!(guest_params)

    if params[:more_guests]
      redirect_to new_admin_party_guest_path(@party, more_guests: true)
    else
      redirect_to admin_party_path(@party)
    end
  end

  def edit
    @guest = @party.guests.find(params[:id])
  end

  def update
    guest = @party.guests.find(params[:id])
    guest.update!(guest_params)
    redirect_to admin_party_path(@party)
  end

  private

  def guest_params
    params.require(:guest).permit(:first_name, :last_name)
  end

  def set_party
    @party = Party.find(params[:party_id])
  end
end
