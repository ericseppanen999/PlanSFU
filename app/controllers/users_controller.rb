class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :create, :add_courses ]

  def index
    @users = User.all
    render json: @users, only: [ :cas_user_id ]
  end


  def taken_courses
    user = find_user_from_token
    # logger.debug("User found: #{user}, token: #{token}")

    if user.nil?
      render json: { error: "User not signed in" }, status: :unauthorized
      return
    end
    detailed_courses = user.taken_courses.map do |taken_course|
      course = Course.find_by(unique_identifier: taken_course["unique_identifier"])
      if course
        course.attributes.merge("grade" => taken_course["grade"] || "C-") # Include the grade
      end
    end.compact
    # logger.debug("Detailed courses: #{detailed_courses}")
    render json: detailed_courses
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


  def update_grade
    user = find_user_from_token
    return render json: { error: "user not found" }, status: :not_found unless user

    unique_identifier = params[:unique_identifier]
    new_grade = params[:grade]
    course = user.taken_courses.find { |c| c["unique_identifier"] == unique_identifier }
    return render json: { error: "course not found" }, status: :not_found unless course
    course["grade"] = new_grade
    if user.save
      render json: { message: "Grade updated successfully", user: user }
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
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
    # logger.debug "adding courses to user"

    user = find_user_from_token
    return render json: { message: "user not found" }, status: :not_found unless user

    new_courses = params[:courses]
    # logger.debug new_courses
    # logger.debug new_courses.class

    return render json: { message: "no courses provided" }, status: :unprocessable_entity unless new_courses.present?

    filtered_courses = filter_new_courses(user, new_courses)
    return render json: { message: "no new courses to add" } if filtered_courses.empty?

    if save_courses(user, filtered_courses)
      render json: { message: "courses added successfully", user: user }
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def remove_course
    user = find_user_from_token
    return render json: { message: "user not found" }, status: :not_found unless user

    unique_identifier = params[:unique_identifier]
    return render json: { message: "invalid course identifier" }, status: :bad_request unless unique_identifier

    user.taken_courses.reject! { |course| course["unique_identifier"] == unique_identifier }

    if user.save
      render json: { message: "Course removed successfully" }
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private


  def find_user_from_token
    session_token = request.headers["Authorization"]&.split(" ")&.last
    User.find_by(session_token: session_token).tap do |user|
      # logger.debug("User found: #{user.inspect}, token: #{session_token}")
    end
  end


  def filter_new_courses(user, new_courses)
    existing_ids = user.taken_courses.map { |course| course["unique_identifier"] }
    new_courses.reject { |course| existing_ids.include?(course["unique_identifier"]) }
  end


  def save_courses(user, filtered_courses)
    user.taken_courses.concat(filtered_courses)
    user.save
  end


  def user_params
    params.require(:user).permit(:username, :password)
  end
end
