require "test_helper"

class PartyTest < ActiveSupport::TestCase
  test "#passed_submission_deadline? when it has been passed" do
    party = Party.new(responses_end_at: 1.week.ago)

    assert_equal true, party.passed_submission_deadline?
  end

  test "#passed_submission_deadline? when it hasn't been passed" do
    party = Party.new(responses_end_at: 1.week.from_now)

    assert_equal false, party.passed_submission_deadline?
  end

  test "#passed_submission_deadline? when responses were submitted more than two days ago" do
    party = Party.new(
      responses_end_at: 1.week.from_now,
      responses_submitted_at: 3.days.ago
    )

    assert_equal true, party.passed_submission_deadline?
  end

  test "#passed_submission_deadline? when responses were recently submitted" do
    party = Party.new(
      responses_end_at: 1.week.from_now,
      responses_submitted_at: 1.hour.ago
    )

    assert_equal false, party.passed_submission_deadline?
  end
end
