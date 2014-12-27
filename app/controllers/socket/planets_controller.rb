class Socket::PlanetsController < WebsocketRails::BaseController
  before_action :authorize

  def info
    puts 'hai'
    puts 'hai'
    puts 'hai'
    puts message.inspect
    planet = Planet.find(message[:planet_id])

    planet_info = {
      name: planet.name,
      connected_ships: planet.connected_ships,
      travel_time: planet.seconds_to(current_user.current_ship.currently_orbiting)
    }

    trigger_success planet_info
  end

private
  def authorize
    raise 'You must be logged in' if current_user.nil?
  end
end
