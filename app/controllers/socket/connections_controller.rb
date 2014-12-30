class Socket::ConnectionsController < WebsocketRails::BaseController
  before_action :authorize

  def connected
    ship = current_user.current_ship

    ship.update_attribute :connected, true
    WebsocketRails[ship.star_system.channel_name].trigger :ship_arrived, ship.as_json(
      include: {
        faction: {},
        currently_orbiting: {
          only: [:id, :name],
          methods: [:class_name]
        }
      },
      methods: [:name_degrees, :orbit_distance_multiplier, :orbit_time_multiplier]
    )
  end

  def disconnected
    ship = current_user.current_ship

    ship.update_attribute :connected, false
    WebsocketRails[ship.star_system.channel_name].trigger :ship_departed, ship.as_json(
      include: {
        faction: {},
        currently_orbiting: {
          only: [:id, :name],
          methods: [:class_name]
        }
      },
      methods: [:name_degrees, :orbit_distance_multiplier, :orbit_time_multiplier]
    )
  end

  def authorize_private_channel
    ship = current_user.current_ship
    authorized = ship.authorized_for_channel? message[:channel]

    if authorized
      accept_channel
    else
      deny_channel
    end
  end

private
  def authorize
    raise 'You must be logged in' if current_user.nil?
  end
end
