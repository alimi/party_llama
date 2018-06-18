class Party < ApplicationRecord
  has_many :guests

  accepts_nested_attributes_for :guests

  attribute :responses_end_at, :datetime, default: DateTime.new(2018, 8, 5, 7)

  def passed_submission_deadline?
    if responses_submitted_at.present?
      (responses_submitted_at + 2.days) < DateTime.current
    else
      responses_end_at < DateTime.current
    end
  end

  def greeting(conjunction: I18n.translate("and"))
    if family_name.present?
      "#{primary_guests.map(&:first_name).join(" #{conjunction} ")} #{family_name}"
    else
      primary_guests.map(&:name).join(" #{conjunction} ")
    end
  end

  def single?
    guests.count == 1
  end

  def attending?
    guests.
      where(attending_patterson_park: true).
      or(guests.where(attending_douglass_myers: true)).
      any?
  end

  private

  def primary_guests
    guests.select(&:primary?)
  end
end
