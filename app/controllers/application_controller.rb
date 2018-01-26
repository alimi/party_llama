class ApplicationController < ActionController::Base
  def current_party
    @current_party ||= Party.find_by(id: session[:current_party_id])
  end
end
