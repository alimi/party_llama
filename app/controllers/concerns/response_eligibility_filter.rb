module ResponseEligibilityFilter
  extend ActiveSupport::Concern

  included do
    before_action :check_response_eligibility
  end

  def check_response_eligibility
    if Current.party.passed_submission_deadline?
      redirect_to conclusion_path
    end
  end
end
