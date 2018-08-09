module Localizer
  extend ActiveSupport::Concern

  included do
    before_action :set_locale
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    if params[:locale].present?
      { locale: I18n.locale }
    else
      {}
    end
  end
end
