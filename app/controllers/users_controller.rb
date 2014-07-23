class UsersController < ApplicationController

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		flash[:success] = "Welcome to STE(A)M Truck!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end 

  private

  	def user_params
  		params.require(:user).permit(:first_name, :last_name, :email, :school, 
  										:password, :password_confirmation) 
  	end
end
