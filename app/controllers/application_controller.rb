class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :pass_current_to_gon
  before_filter :set_locale

  def pass_current_to_gon
    gon.controller = controller_name.downcase
    gon.action = action_name.downcase
  end

  def set_locale
    logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    lc = extract_locale_from_accept_language_header
    I18n.locale = lc if lc.present?
    logger.debug "* Locale set to '#{I18n.locale}'"
  end

  private

  def extract_locale_from_accept_language_header
    acl = request.env['HTTP_ACCEPT_LANGUAGE']
    result = acl.scan(/^[a-z]{2}/).first if acl.present?
    result || I18n.default_locale
  end
end
