class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :pass_current_to_gon

  def pass_current_to_gon
    gon.controller = controller_name.downcase
    gon.action = action_name.downcase
  end
end
