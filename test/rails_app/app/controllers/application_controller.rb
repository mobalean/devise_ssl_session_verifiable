# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_admin!, :unless => :devise_controller?
  respond_to *Mime::SET.map(&:to_sym)
end
