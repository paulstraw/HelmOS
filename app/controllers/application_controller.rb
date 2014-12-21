class ApplicationController < ActionController::Base
  force_ssl if Rails.env.production? || Rails.env.staging?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_namespace

  def authorize
    redirect_to(sign_in_path(next: request.original_url)) && return if current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by(tg_auth_token: cookies.signed[:tg_auth_token]) if cookies.signed[:tg_auth_token]

    cookies.delete :tg_auth_token if @current_user.nil?

    return @current_user
  end
  helper_method :current_user

private
  def set_namespace
    @namespace = controller_path.split('/').first
  end
end
