class ApplicationController < ActionController::Base
  protect_from_forgery
  #force_ssl

  before_filter :requires_authentication

  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  protected

  def requires_authentication
    if request.format == "application/json" then
      authenticate_or_request_with_http_basic do |email_address, password|
        user = User.find_by_email_address(email_address)
        if user && user.authenticate(password) then
          session[:user_id] = user.id
        end
      end
    else 
      if !current_user then
        redirect_to new_user_session_path
      end
    end
  end

  private

  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
