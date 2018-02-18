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

  test "#passed_submission_deadline? when it hasn't been set" do
    party = Party.new

    assert_equal true, party.passed_submission_deadline?
  end
end
