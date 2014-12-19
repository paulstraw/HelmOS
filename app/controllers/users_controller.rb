class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      cookies.permanent.signed[:tg_auth_token] = @user.tg_auth_token

      redirect_to :root
    else
      render :new
    end
  end

private
  def user_params
    params.require(:user).permit(
      :email,
      :username,
      :password,
    )
  end
end
