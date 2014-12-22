class Socket::ShipsController < Socket::ApplicationController
  before_action :authorize


  def travel

  end

  def method_name

  end

private
  def authorize
    raise 'You must be logged in' if current_user.nil?
  end
end
