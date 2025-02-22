class RegistrationsController < ApplicationController
    def new
        @user = User.new
    end

    def create
        @user = User.new(registration_params)
        if @user.save
            session[:user_id] = @user.id # Set session ID on successful signup
            redirect_to root_path, notice: "Account created successfully"
        else
            render :new, status: :unprocessable_entity
        end
    end

    private

    def registration_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
