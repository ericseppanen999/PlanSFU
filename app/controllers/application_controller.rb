# class ApplicationController < ActionController::Base
#   before_action :set_current_user

#   private

#   def authenticate_user!
#     redirect_to login_path, alert: "You must be logged in to do that." unless user_signed_in?
#   end

#   def current_user
#     Current.user ||= authenticate_user_from_session
#   end
#   helper_method :current_user

#   def authenticate_user_from_session
#     User.find_by(id: session[:user_id])
#   end

#   def user_signed_in?
#     current_user.present?
#   end
#   helper_method :user_signed_in?

#   def login(user)
#     Current.user = user
#     reset_session
#     session[:user_id] = user.id
#   end

#   def logout
#     Current.user = nil
#     reset_session
#   end

#   def set_current_user
#     if session[:user_id]
#       Current.user = User.find_by(id: session[:user_id])
#     end
#   end
# end

# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  def authenticate_user!
    unless current_user
      respond_to do |format|
        format.html { redirect_to login_path, alert: "You must be logged in." }
        format.json { render json: { error: "Unauthorized" }, status: :unauthorized }
      end
    end
  end

  def user_signed_in?
    current_user.present?
  end
  helper_method :user_signed_in?

  def login(user)
    session[:user_id] = user.id
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
  end
end
