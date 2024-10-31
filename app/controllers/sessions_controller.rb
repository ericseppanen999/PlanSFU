class SessionsController < ApplicationController
    
    def new
        @user = User.new
    end

    def create
        
        Rails.logger.info "Received params: #{params.inspect}"

        if params[:user].present?
            
            user = User.find_by(email: params[:user][:email])&.authenticate(params[:user][:password])
            if user
                login user
                redirect_to root_path, notice: "You have signed in successfully."
            else
                flash[:alert] = "Invalid email or password."
                render :new, status: :unprocessable_entity
            end
        else
            flash[:alert] = "Email and password must be provided."
            render :new, status: :unprocessable_entity
        end
    end
    
    
    def destroy
        logout current_user
        redirect_to root_path, notice: "you have been logged out."
    end
end
