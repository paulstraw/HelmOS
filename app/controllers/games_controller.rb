class GamesController < ApplicationController
  before_action :authorize

  def index
    redirect_to(:new_ship) && return unless current_user.ships.count > 0
  end
end
