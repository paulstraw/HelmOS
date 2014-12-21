class ShipsController < ApplicationController
  before_action :authorize

  def new
    redirect_to(:back) && return unless current_user.ships.count == 0

    @ship = Ship.new
  end

  def create
    redirect_to(:back) && return unless current_user.ships.count == 0

    @ship = Ship.new(ship_params)
    @ship.captain = current_user

    if @ship.save
      redirect_to :root
    else
      render :new
    end
  end

private
  def ship_params
    params.require(:ship).permit(
      :name,
      :faction_id
    )
  end
end
