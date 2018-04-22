class Party < ApplicationRecord
  has_many :guests

  def passed_submission_deadline?
    if responses_end_at.blank?
      true
    else
      responses_end_at && responses_end_at < DateTime.current
    end
  end

  def name
    if single?
      guests.first.name
    else
      super
    end
  end

  def single?
    guests.count == 1
  end
end
