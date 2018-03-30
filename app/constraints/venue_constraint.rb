class VenueConstraint
  def matches?(request)
    venues.include?(request.params[:venue])
  end

  private

  def venues
    ["patterson_park", "douglass_myers"]
  end
end
