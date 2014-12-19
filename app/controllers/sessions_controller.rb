class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email].downcase)

    if user && user.authenticate(params[:password])
      # sign the user in
      cookies.permanent.signed[:tg_auth_token] = user.tg_auth_token
      user.touch :last_login

      if params[:next]
        redirect_to params[:next]
      else
        redirect_to :root
      end
    else
      render nothing: true, status: 404
    end
  end

  def destroy
    current_user.reset_auth_token if current_user

    cookies.delete(:tg_auth_token)
    reset_session

    redirect_to :root, notice: 'You\'ve been signed out. See you again soon!'
  end
end
