class Socket::SatellitesController < WebsocketRails::BaseController
  before_action :authorize

  def info
    satellite = Satellite.find(message[:satellite_id])

    satellite_info = {
      name: satellite.name,
      id: satellite.id,
      orbiting_name: satellite.orbitable.name,
      class_name: satellite.class_name,
      connected_ships: satellite.connected_ships,
      travel_time: current_user.current_ship.seconds_to(satellite)
    }

    trigger_success satellite_info
  end

private
  def authorize
    raise 'You must be logged in' if current_user.nil?
  end
end
