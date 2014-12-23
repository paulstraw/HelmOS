class Socket::ConnectionsController < WebsocketRails::BaseController
  before_action :authorize

  def connected
    ship = current_user.current_ship

    ship.update_attribute :connected, true
    WebsocketRails[ship.currently_orbiting.channel_name].trigger :ship_arrived, ship
  end

  def disconnected
    ship = current_user.current_ship

    ship.update_attribute :connected, false
    WebsocketRails[ship.currently_orbiting.channel_name].trigger :ship_departed, ship
  end

private
  def authorize
    raise 'You must be logged in' if current_user.nil?
  end
end
