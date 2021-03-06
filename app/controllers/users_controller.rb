class UsersController < ApplicationController
	# before_action :signed_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
 #  before_action :correct_user,   only: [:edit, :update]
 #  before_action :admin_user,     only: :destroy
 #  before_action :signed_out_user, only: [:new, :create]
 after_filter :cors_set_access_control_headers

  def show 
		 @user = User.find(params[:id])
     @microposts = @user.microposts.paginate(page: params[:page])
	end 

	def new
		@user = User.new
	end

	def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      else
      render 'new'
    end
  end

  def edit
  end 

  def index
    # @users = User.paginate(page: params[:page], per_page: 30)    
    @users = User.all
    render json: @users
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :avatar)
    end
 
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def signed_out_user
      redirect_to root_path unless signed_out?
    end 
end
