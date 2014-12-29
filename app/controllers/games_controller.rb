class GamesController < ApplicationController
  before_action :authorize

  def index
    redirect_to(:new_ship) && return unless current_user.ships.count > 0


    # boostrap necessary game data
    orbiting = current_user.current_ship.currently_orbiting

    gon.current_user = current_user
    gon.current_ship = current_user.current_ship.as_json(
      methods: [:current_channel_names, :name_degrees, :orbit_distance_multiplier, :orbit_time_multiplier],
      include: [:travelling_to],
    )
    gon.currently_orbiting = orbiting.is_a?(Planet) ?
      orbiting.as_json(
        methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees, :class_name, :sub_val],
        include: {
          connected_ships: {
            include: [:faction],
            methods: [:name_degrees, :orbit_distance_multiplier, :orbit_time_multiplier]
          },
          satellites: {
            methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees, :sub_val]
          }
        }
      ) :
      orbiting.as_json(
        methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees, :class_name, :sub_val],
        include: {
          connected_ships: {
            include: [:faction],
            methods: [:name_degrees, :orbit_distance_multiplier, :orbit_time_multiplier]
          },
          orbitable: {
            methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees, :sub_val]
          }
        }
      )
    gon.current_star = current_user.current_ship.currently_orbiting.star.as_json(
      methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees],
      include: {
        planets: {
          methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees, :class_name, :sub_val],
          include: {
            satellites: {
              methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees, :class_name, :sub_val],
              connected_ships: {
                include: {
                  faction: {},
                  currently_orbiting: {
                    methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees, :class_name, :sub_val]
                  }
                },
                methods: [:name_degrees, :orbit_distance_multiplier, :orbit_time_multiplier]
              },
            },
            connected_ships: {
              include: {
                faction: {},
                currently_orbiting: {
                  methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees, :class_name, :sub_val]
                }
              },
              methods: [:name_degrees, :orbit_distance_multiplier, :orbit_time_multiplier]
            },
          }
        }
      }
    )
  end
end
