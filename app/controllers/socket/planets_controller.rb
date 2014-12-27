class Socket::PlanetsController < WebsocketRails::BaseController
  before_action :authorize

  def info
    planet = Planet.find(message[:planet_id])

    planet_info = {
      name: planet.name,
      id: planet.id,
      class_name: planet.class_name,
      connected_ships: planet.connected_ships,
      travel_time: current_user.current_ship.seconds_to(planet)
    }

    trigger_success planet_info
  end

private
  def authorize
    raise 'You must be logged in' if current_user.nil?
  end
end
