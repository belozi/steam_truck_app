class UsersController < ApplicationController

  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,  only: :destroy

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to STE(A)M Truck!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end 

  def edit 
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  private

  	def user_params
  		params.require(:user).permit(:first_name, :last_name, :email, :school, 
  										:password, :password_confirmation) 
  	end

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in." 
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
