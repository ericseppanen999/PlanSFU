module Web
  class SessionsController < ApplicationController
    def new
      @user = User.new
    end

    def create
      Rails.logger.info "Received params: #{params.inspect}"

      if params[:user].present?
        user = User.find_by(username: params[:user][:username])&.authenticate(params[:user][:password])

        if user
          login user
          redirect_to root_path, notice: "You have signed in successfully."
        else
          flash[:alert] = "Invalid username or password."
          render :new, status: :unprocessable_entity
        end
      else
        flash[:alert] = "Username and password must be provided."
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      logout
      redirect_to root_path, notice: "You have been logged out."
    end

    private

    def login(user)
      session[:user_id] = user.id
    end

    def logout
      session.delete(:user_id)
      @current_user = nil
    end
  end
end
