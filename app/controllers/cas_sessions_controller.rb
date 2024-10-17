=begin 

JUST REMOVE "=begin" AND "=end" TO REMOVE COMMENTS!

class CasSessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  # Initiates the CAS login by redirecting the user to the CAS server
  def new
    redirect_to cas_login_url, allow_other_host: true
  end

  # Processes the CAS callback, validates the ticket, and logs in the user
  def create
    if params[:ticket]
      Rails.logger.info "Received CAS ticket: #{params[:ticket]}"  # Log CAS ticket received

      # Validate the CAS ticket and retrieve user information
      user_info = validate_cas_ticket(params[:ticket])

      if user_info
        # Store the user ID (e.g., amb35) in the session
        session[:cas_user] = user_info[:user_id]

        # Find or create the user in the local database
        @current_user = User.find_or_create_by(user_id: user_info[:user_id])

        # Set the current user by storing the user's ID in the session
        session[:current_user_id] = @current_user.id

        Rails.logger.info "CAS User Info: #{user_info[:user_id]}"  # Log CAS user info

        # Redirect to the originally requested page, or to the homepage
        redirect_to session.delete(:return_to) || root_path
      else
        flash[:error] = "CAS authentication failed. Please try again."
        Rails.logger.error "CAS authentication failed"  # Log CAS failure
        redirect_to login_path
      end
    else
      flash[:error] = "No CAS ticket provided. Please log in."
      Rails.logger.error "No CAS ticket provided"  # Log missing CAS ticket
      redirect_to login_path
    end
  end

  # Logs out the user by clearing the session and redirecting to CAS logout
  def destroy
    reset_session
    redirect_to cas_logout_url
  end

  private

  # Generate the CAS login URL with a callback URL
  def cas_login_url
    "#{CAS_BASE_URL}/login?service=#{callback_url}"
  end

  # Generate the CAS logout URL with a callback to the root URL
  def cas_logout_url
    "#{CAS_BASE_URL}/logout?service=#{root_url}"
  end

  # Define the callback URL that CAS should redirect to after authentication
  def callback_url
    "#{root_url}cas_sessions/create"
  end

  # Validate CAS ticket by sending it to the CAS server
  def validate_cas_ticket(ticket)
    return nil unless ticket

    cas_client = CASClient::Client.new(
      cas_base_url: CAS_BASE_URL,
      login_url: "#{CAS_BASE_URL}/login",
      service_validate_url: "#{CAS_BASE_URL}/serviceValidate",
      service_url: "#{root_url}cas_sessions/create"
    )

    begin
      # Validate the CAS ticket with the CAS server
      response = cas_client.validate_service_ticket(ticket)
      Rails.logger.info "CAS ticket validation response: #{response.inspect}"  # Log CAS validation response
    rescue StandardError => e
      Rails.logger.error "Error validating CAS ticket: #{e.message}"  # Log error during validation
      return nil
    end

    # If the ticket is successfully validated, return the user's information
    if response && response.success?
      { user_id: response.user }  # Return user_id instead of email
    else
      Rails.logger.warn "CAS ticket validation failed: #{response.inspect}"  # Log failed validation
      nil
    end
  end
end

=end
