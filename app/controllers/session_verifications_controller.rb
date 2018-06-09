class SessionVerificationsController < ApplicationController
  include PartyAuthentication

  def new
    @options = [Option.new(true), Option.new(false)]
  end

  def create
    if params[:session_verifications][:verified] == "true"
      redirect_to introduction_path
    else
      redirect_to new_session_path
    end
  end

  Option = Struct.new(:value) do
    def text
      I18n.translate(value)
    end
  end
end
