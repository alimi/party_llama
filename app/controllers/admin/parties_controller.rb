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

  def new
    @party = Party.new
  end

  def create
    party = Party.create!(party_params)
    redirect_to admin_party_guests_path(party)
  end

  private

  def party_params
    params.require(:party).permit(:name, :responses_end_at)
  end
end
