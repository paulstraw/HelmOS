class GamesController < ApplicationController
  before_action :authorize

  def index
    redirect_to(:new_ship) && return unless current_user.ships.count > 0

    gon.current_user = current_user.as_json(only: [:id, :email, :username])
  end
end
