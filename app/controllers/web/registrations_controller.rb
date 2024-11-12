# app/controllers/web/registrations_controller.rb
module Web
    class RegistrationsController < ApplicationController
      def new
        @user = User.new
      end
  
      def create
        @user = User.new(user_params)
        if @user.save
          redirect_to login_path, notice: 'Signed up successfully!'
        else
          render :new, status: :unprocessable_entity
        end
      end
  
      private
  
      def user_params
        params.require(:user).permit(:username, :password, :password_confirmation)
      end
    end
  end