class UsersController < ApplicationController
before_action :logged_in_user, only: [:index,:edit, :update, :destroy,:following, :followers]
before_action :correct_user, only: [:edit, :update]
before_action :admin_user,     only: :destroy

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def index
    @users = User.paginate(page: params[:page])
    
  end
  
  def create
    @user = User.create(user_params)
    if  @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      #remember @user
      #log_in @user
      #flash[:success] = "Welcome to the Sample App"
      #redirect_to user_path(@user.id)
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
    flash.now[:success] = "update your profile"
    redirect_to @user
  else
    flash.now[:danger] = "failure your profile"
    render 'edit'
  end
end

def destroy
  @user = User.find(params[:id])
  @user.destroy
  flash[:success] = "{@user.name},goodbye"
  redirect_to users_url
end
  
  # GET users/:id/following
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  # GET users/:id/followers
  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  
  private
  
  def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
      flash[:danger] = "不正にアクセスしようとしたのかい？"
      redirect_to root_url 
    end
  end
  
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  end