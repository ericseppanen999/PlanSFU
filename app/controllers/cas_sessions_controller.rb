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
        # Set session and current user based on CAS response
        session[:cas_user] = user_info[:email]
        @current_user = User.find_or_create_by(email: user_info[:email])

        Rails.logger.info "CAS User Info: #{user_info[:email]}"  # Log CAS user info

        # Ensure user is logged in before redirection
        unless @current_user
          flash[:error] = "Could not find or create user."
          Rails.logger.error "Could not find or create user"  # Log user creation failure
          redirect_to login_path and return
        end

        # Redirect to the originally requested page or the root path
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

  def destroy
    reset_session
    redirect_to cas_logout_url
  end

  private

  def cas_login_url
    "#{CAS_BASE_URL}/login?service=#{callback_url}"
  end

  def cas_logout_url
    "#{CAS_BASE_URL}/logout?service=#{root_url}"
  end

  def callback_url
    "#{root_url}cas_sessions/create"  # This URL will now handle both GET and POST
  end

  # Validate CAS ticket and handle response
  def validate_cas_ticket(ticket)
    return nil unless ticket

    cas_client = CASClient::Client.new(
      cas_base_url: CAS_BASE_URL,
      login_url: "#{CAS_BASE_URL}/login",
      service_validate_url: "#{CAS_BASE_URL}/serviceValidate",
      service_url: "#{root_url}cas_sessions/create"
    )

    begin
      response = cas_client.validate_service_ticket(ticket)
      Rails.logger.info "CAS ticket validation response: #{response.inspect}"  # Log CAS validation response
    rescue StandardError => e
      Rails.logger.error "Error validating CAS ticket: #{e.message}"  # Log error during validation
      return nil
    end

    if response && response.success?
      { email: response.user }
    else
      Rails.logger.warn "CAS ticket validation failed: #{response.inspect}"  # Log failed validation
      nil
    end
  end
end

=end