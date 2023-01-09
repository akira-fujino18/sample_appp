class SessionsController < ApplicationController
  def new
  end
  
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    # =>上記文でDBに一致するemailが存在するか実行
    if !@user.nil? && @user.authenticate(params[:session][:password])
      log_in(@user)
      if params[:session][:remember_me] == '1'
      remember(@user)
      else
      forget(@user)
      end
      flash[:success] = 'login success!'
      redirect_back_or @user
    # =>find_byだと空白文字が返ってきた時,nilとして返してしまうためnilガードを敷き、passwordがauthenticateと合致するかチェック
    else
    flash.now[:danger] = 'invalid email or password'
    render 'new'
  end
end

def destroy
    log_out if logged_in?
    redirect_to root_url
  end


def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end