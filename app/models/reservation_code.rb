module ReservationCode
  def self.generate(existing_reservation_codes: Party.pluck(:reservation_code))
    reservation_code = rand(100000..999999)

    if existing_reservation_codes.include?(reservation_code)
      generate
    else
      reservation_code
    end
  end
end
