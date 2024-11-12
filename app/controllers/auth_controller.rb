# app/controllers/api/auth_controller.rb
module Api
    class AuthController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_user, except: [:login, :signup]
  
      def login
        user = User.find_by(username: params[:user][:username])
        if user&.authenticate(params[:user][:password])
          session_token = generate_session_token(user)
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
  
      private
  
      def user_params
        params.require(:user).permit(:username, :password, :password_confirmation)
      end
  
      def generate_session_token(user)
        payload = {
          user_id: user.id,
          username: user.username,
          exp: 24.hours.from_now.to_i
        }
        JWT.encode(payload, Rails.application.credentials.secret_key_base)
      end
  
      def authenticate_user
        header = request.headers['Authorization']
        token = header.split(' ').last if header
        begin
          decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
          @current_user = User.find(decoded['user_id'])
        rescue JWT::DecodeError
          render json: { error: 'Invalid token' }, status: :unauthorized
        end
      end
    end
  end