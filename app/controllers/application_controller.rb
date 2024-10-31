class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # commented to allow lighthouse
  # allow_browser versions: :modern

  private 

  def authenticate_user!
    redirect_to root_path, alert: "You must be logged in to do that." unless user_signed_in?
  end

  def current_user
    Current.user ||= authenticate_user_from_session
  end
  helper_method :current_user

  def authenticate_user_from_session
    User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end
  helper_method :user_signed_in?

  def login(user)
    Current.user = user
    reset_session
    session[:user_id] = user.id
  end

  def logout(user)
    Current.user = nil
    reset_session
  end

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

  # Require user to be authenticated before accessing certain actions
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
