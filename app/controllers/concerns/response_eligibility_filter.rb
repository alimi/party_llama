module ResponseEligibilityFilter
  extend ActiveSupport::Concern

  included do
    before_action :check_response_eligibility
  end

  def check_response_eligibility
    if DateTime.current > Current.party.responses_end_at
      redirect_to conclusion_path
    end
  end
end
