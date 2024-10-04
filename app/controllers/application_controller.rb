class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_user
  before_action :authenticate_user!

  def set_current_user
    if session[:cas_user]
      @current_user = User.find_by(email: session[:cas_user])
    end
  end

  def current_user
    @current_user
  end

  def authenticate_user!
    redirect_to cas_login_path unless current_user
  end

  private

  def cas_login_url
    "#{CAS_BASE_URL}/login?service=#{callback_url}"
  end

  def callback_url
    "#{root_url}cas_sessions/create"
  end
end