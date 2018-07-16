class Admin::PartiesController < Admin::ApplicationController
  include AdminAuthentication

  def index
    @parties = Party.
      includes(:guests).
      order("responses_submitted_at IS NULL, responses_submitted_at DESC")

    @parties = if ["patterson_park", "douglass_myers"].include?(params[:attending])
                 @parties.where.not(responses_submitted_at: nil).
                   joins(:guests).
                   where(guests: { "attending_#{params[:attending]}": true })
               elsif params[:attending] == "unknown"
                 @parties.where(responses_submitted_at: nil)
               elsif params[:messages] == "true"
                 @parties.where.not(messages: "{}")
               else
                 @parties
               end

    @counts = Counts.new
  end

  def show
    @party = Party.includes(:guests).find(params[:id])
  end

  def new
    @party = Party.new
    2.times { @party.guests.build }
  end

  def create
    party = Party.new
    party.assign_attributes(new_party_params)
    party.reservation_code = ReservationCode.generate
    party.save!

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
    party_params.tap do |party_params|
      party_params[:guests_attributes] = party_params[:guests_attributes].
        select { |id, guest_attribute| guest_attribute[:first_name].present? }
    end
  end

  def party_params
    params.require(:party).permit(
      :family_name,
      :responses_end_at,
      guests_attributes: [:primary, :first_name, :last_name]
    )
  end

  class Counts
    def invited
      Guest.count
    end

    def patterson_park
      Guest.joins(:party).
        where.not(parties: { responses_submitted_at: nil }).
        where(attending_patterson_park: true).
        count
    end

    def douglass_myers
      Guest.joins(:party).
        where.not(parties: { responses_submitted_at: nil }).
        where(attending_douglass_myers: true).
        count
    end

    def not_responded
      Guest.joins(:party).
        where(parties: { responses_submitted_at: nil }).
        count
    end

    def messages
      Party.sum("cardinality(messages)")
    end
  end
end
