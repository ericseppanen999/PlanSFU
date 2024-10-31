class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :create, :add_courses ]

  def index
    @users = User.all
    render json: @users, only: [ :cas_user_id ]
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      # Generate session token for the user
      session_token = SecureRandom.hex(16)
      
      # Store session token in user's session (or database if you’re saving tokens)
      session[:session_token] = session_token
      
      # Send the session token to the frontend in a JSON response
      render json: { session_token: session_token, message: "Account created successfully" }, status: :created
    else
      # If there’s an error saving the user, return the error messages in JSON
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by(cas_user_id: params[:id])
    if @user
      render json: @user
    else
      render json: { message: "user not found" }, status: :not_found
    end
  end

  def add_courses
    logger.debug "Adding courses to user"
    @user = User.find_by(cas_user_id: params[:id])
    if @user
      new_courses = params[:courses]
      logger.debug new_courses
      logger.debug new_courses.class
      if new_courses.present?
        @user.taken_courses += new_courses
        if @user.save
          render json: { message: "courses added successfully", user: @user }
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { message: "no courses provided" }, status: :unprocessable_entity
      end
    else
      render json: { message: "user not found" }, status: :not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
