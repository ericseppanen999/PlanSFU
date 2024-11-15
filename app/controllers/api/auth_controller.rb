module Api
  class AuthController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user, except: [:login, :signup]

    def login
      user = User.find_by(username: params[:username])
      if user&.authenticate(params[:password])
        session_token = generate_session_token(user)
        user.update(session_token: session_token)
        render json: {
          session_token: session_token,
          user: {
            username: user.username,
            id: user.id
          },
          courses: user.user_search_histories
        }
      else
        render json: { error: 'Invalid username or password' }, status: :unauthorized
      end
    end

    def signup
      user = User.new(user_params)
      if user.save
        session_token = generate_session_token(user)
        user.update(session_token: session_token)
        render json: {
          session_token: session_token,
          user: {
            username: user.username,
            id: user.id
          }
        }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def logout
      if @current_user
        @current_user.update(session_token: nil)
        head :no_content
      else
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end

    private

    def user_params
      params.permit(:username, :password, :password_confirmation)
    end

    def generate_session_token(user)
      SecureRandom.hex(10)
    end

    def authenticate_user
      if request.headers['Authorization'].present?
        token = request.headers['Authorization'].split(' ').last
        @current_user = User.find_by(session_token: token)
        render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
      else
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
  end
end