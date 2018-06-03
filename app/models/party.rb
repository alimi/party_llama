class Party < ApplicationRecord
  has_many :guests

  accepts_nested_attributes_for :guests

  def passed_submission_deadline?
    if responses_end_at.blank?
      true
    else
      responses_end_at && responses_end_at < DateTime.current
    end
  end

  def greeting(conjunction: I18n.translate("and"))
    if family_name.present?
      "#{guests.primary.map(&:first_name).join(" #{conjunction} ")} #{family_name}"
    else
      guests.primary.map(&:name).join(" #{conjunction} ")
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
end
