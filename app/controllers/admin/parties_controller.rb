class Admin::PartiesController < ApplicationController
  include AdminAuthentication

  def index
    @parties = Party.includes(:guests).all

    @invited_guest_count = Guest.count

    @attending_patterson_park_count = Guest.joins(:party).
      where.not(parties: { responses_submitted_at: nil }).
      where(attending_patterson_park: true).
      count

    @attending_douglass_myers_count = Guest.joins(:party).
      where.not(parties: { responses_submitted_at: nil }).
      where(attending_douglass_myers: true).
      count

    @no_response_party_count = Party.where(responses_submitted_at: nil).count
  end

  def show
    @party = Party.includes(:guests).find(params[:id])
  end

  def new
    @party = Party.new
    2.times { @party.guests.build }
  end

  def create
    party = Party.create!(new_party_params)

    if params[:more_guests]
      redirect_to new_admin_party_guest_path(party, more_guests: true)
    else
      redirect_to admin_parties_path
    end
  end

  def edit
    @party = Party.includes(:guests).find(params[:id])
  end

  def update
    party = Party.find(params[:id])
    party.update!(party_params)
    redirect_to admin_parties_path
  end

  private

  def new_party_params
    party_params.tap do |party_param|
      party_param[:guests_attributes] = party_param[:guests_attributes].
        select { |id, guest_attribute| guest_attribute[:first_name].present? }
    end
  end

  def party_params
    params.require(:party).permit(
      :family_name,
      :responses_end_at,
      guests_attributes: [:first_name, :last_name]
    )
  end
end
