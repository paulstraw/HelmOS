class ShipsController < ApplicationController
  before_action :authorize

  def new
    @ship = Ship.new
  end

  def create
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
      :faction
    )
  end
end
