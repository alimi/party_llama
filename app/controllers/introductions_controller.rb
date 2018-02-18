class IntroductionsController < ApplicationController
  include PartyAuthentication
  include ResponseEligibilityFilter

  def show
  end
end
