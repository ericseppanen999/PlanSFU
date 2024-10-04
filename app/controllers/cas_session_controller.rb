class CasSessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  # Initiates the CAS login by redirecting the user to the CAS server
  def new
    redirect_to cas_login_url
  end

  # Processes the CAS callback, validates the ticket, and logs in the user
  def create
    if params[:ticket]
      # Validate the CAS ticket and retrieve user information
      user_info = validate_cas_ticket(params[:ticket])

      if user_info
        # Set session and current user based on CAS response
        session[:cas_user] = user_info[:email]
        @current_user = User.find_or_create_by(email: user_info[:email])

        # Redirect to the originally requested page or the root path
        redirect_to session.delete(:return_to) || root_path
      else
        flash[:error] = "CAS authentication failed. Please try again."
        redirect_to login_path
      end
    else
      flash[:error] = "No CAS ticket provided. Please log in."
      redirect_to login_path
    end
  end

  def destroy
    reset_session
    redirect_to cas_logout_url
  end

  private

  def cas_login_url
    # Construct the CAS login URL with the service callback URL
    "#{CAS_BASE_URL}/login?service=#{callback_url}"
  end

  def cas_logout_url
    "#{CAS_BASE_URL}/logout?service=#{root_url}"
  end

  def callback_url
    # URL to which CAS should redirect after successful login
    "#{root_url}cas_sessions/create"
  end

  def validate_cas_ticket(ticket)
    # Replace this with actual ticket validation logic, which might involve
    # sending a request to the CAS server and parsing the response.
    # For example, using RubyCAS or Devise-CAS-Authenticatable.
    response = CASClient::Client.new.validate_service_ticket(ticket)
    
    if response.success?
      { email: response.user }
    else
      nil
    end
  end
end