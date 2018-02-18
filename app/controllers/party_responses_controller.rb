class PartyResponsesController < ApplicationController
  include PartyAuthentication
  include ResponseEligibilityFilter

  def index
    @party_responses = PartyResponses.new(Current.party)
  end

  PartyResponses = Struct.new(:party) do
    def for_patterson_park
      GuestResponses.new(patterson_park_guests).to_s
    end

    def for_douglass_myers
      GuestResponses.new(douglass_myers_guests).to_s
    end

    private

    def patterson_park_guests
      @patterson_park_guests ||=
        party.guests.where(attending_patterson_park: true)
    end

    def douglass_myers_guests
      @douglass_myers_guests ||=
        party.guests.where(attending_douglass_myers: true)
    end
  end

  GuestResponses = Struct.new(:guests) do
    def count
      guests.count
    end

    def names
      guests.map(&:name).to_sentence
    end

    def to_s
      if count > 0
        "#{count} guests attending: #{names}"
      else
        "0 guests attending"
      end
    end
  end
end
