class Socket::BootstrapController < WebsocketRails::BaseController
  before_action :authorize

  def data
    ship = current_user.current_ship
    star = ship.currently_orbiting.star

    # handle the actual "connection-y" parts
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


    current_ship = ship.as_json(
      methods: [:current_channel_names, :name_degrees, :orbit_distance_multiplier, :orbit_time_multiplier],
      include: {
        travelling_to: {
          only: [:name, :id],
          methods: [:class_name]
        },
        currently_orbiting: {
          only: [:name, :id],
          methods: [:class_name]
        }
      }
    )

    current_star_system = ship.star_system.as_json(
      only: [:name, :id],
      methods: [:channel_name]
    )

    current_star = star.as_json(
      methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees, :class_name],
      only: [:name, :id, :x, :y, :radius]
    )

    current_planets = star.planets.as_json(
      methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees, :class_name, :sub_val],
      only: [:name, :id, :apogee, :perigee, :radius]
    )

    current_satellites = star.satellites.as_json(
      methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees, :class_name, :sub_val],
      only: [:name, :id, :orbitable_id, :orbitable_type, :apogee, :perigee, :radius]
    )

    connected_ships = star.connected_ships.as_json(
      include: {
        faction: {},
        currently_orbiting: {
          only: [:id, :name],
          methods: [:class_name]
        }
      },
      methods: [:name_degrees, :orbit_distance_multiplier, :orbit_time_multiplier]
    )

    # send back bootstrap data
    trigger_success({
      current_ship: current_ship,
      star: current_star,
      star_system: current_star_system,
      planets: current_planets,
      satellites: current_satellites,
      ships: connected_ships
    })
  end


private
  def authorize
    raise 'You must be logged in' if current_user.nil?
  end
end
