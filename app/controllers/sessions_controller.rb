# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def new
    redirect_to lists_path if current_user
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to lists_path, notice: "Login successful!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logout successful!"
  end
end