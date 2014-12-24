class GamesController < ApplicationController
  before_action :authorize

  def index
    redirect_to(:new_ship) && return unless current_user.ships.count > 0


    # boostrap necessary game data
    orbiting = current_user.current_ship.currently_orbiting

    gon.current_user = current_user
    gon.current_ship = current_user.current_ship.as_json(
      methods: [:current_channel_names]
    )
    gon.currently_orbiting = orbiting.is_a?(Planet) ?
      orbiting.as_json(
        methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees],
        include: {
          connected_ships: {
            include: [:faction]
          },
          satellites: {
            methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees]
          }
        }
      ) :
      orbiting.as_json(
        methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees],
        include: {
          connected_ships: {
            include: [:faction]
          },
          orbitable: {
            methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees]
          }
        }
      )
    gon.current_star = current_user.current_ship.currently_orbiting.star.as_json(
      methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees],
      include: {
        planets: {
          methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees],
          include: {
            satellites: {
              methods: [:channel_name, :name_hex_color, :name_rgb_color, :name_degrees],
              connected_ships: {
                include: [:faction]
              },
            },
            connected_ships: {
              include: [:faction]
            },
          }
        }
      }
    )
  end
end
