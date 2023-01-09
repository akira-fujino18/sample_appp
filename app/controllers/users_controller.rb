class UsersController < ApplicationController
before_action :logged_in_user, only: [:index,:edit, :update, :destroy]
before_action :correct_user, only: [:edit, :update]
before_action :admin_user , only: :destroy
  def show
    @user = User.find(params[:id])
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
      remember @user
      log_in @user
      flash[:success] = "Welcome to the Sample App"
      redirect_to user_path(@user.id)
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
  
  private
  
  def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
  end
  
  # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしないとだめだね"
        redirect_to login_url
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
      flash[:danger] = "不正にアクセスしようとしたのかい？"
      redirect_to root_url 
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  end
  
  