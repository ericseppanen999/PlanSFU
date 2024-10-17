class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end

=begin 

JUST REMOVE "=begin" AND "=end" TO REMOVE COMMENTS!

  before_action :set_current_user
  before_action :authenticate_user!

  # Set the current user based on CAS session data
  def set_current_user
    if session[:cas_user]
      Rails.logger.info "Session CAS user: #{session[:cas_user]}"  # Log session user
      @current_user = User.find_by(user_id: session[:cas_user])  # Using user_id instead of email
      Rails.logger.info "Current User: #{@current_user&.user_id}"   # Log if current user found
    end
  end

  # Helper method to access the current user
  def current_user
    @current_user
  end

  # Require users to be authenticated before accessing certain actions
  def authenticate_user!
    unless current_user
      Rails.logger.info "User not authenticated. Redirecting to login."  # Log when redirecting to login
      redirect_to login_path
    else
      Rails.logger.info "User authenticated as #{current_user.user_id}"   # Log authenticated user
    end
  end
end

=end
