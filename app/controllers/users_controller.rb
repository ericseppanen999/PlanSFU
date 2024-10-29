class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :create, :add_courses ]

  def index
    @users = User.all
    render json: @users, only: [ :cas_user_id ]
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: { message: "User created successfully", user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by(cas_user_id: params[:id])
    if @user
      render json: @user
    else
      render json: { message: "User not found" }, status: :not_found
    end
  end

  def add_courses
    @user = User.find_by(cas_user_id: params[:id])
    if @user
      new_courses = params[:courses]
      if new_courses.present?
        @user.taken_courses += new_courses
        if @user.save
          render json: { message: "Courses added successfully", user: @user }
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { message: "No courses provided" }, status: :unprocessable_entity
      end
    else
      render json: { message: "User not found" }, status: :not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:cas_user_id, taken_courses: [ :course_code, :term ])
  end
end
