class Socket::ShipsController < WebsocketRails::BaseController
  before_action :authorize

  def begin_travel
    destination_class = Object.const_get message[:destination_class]
    destination = destination_class.find(message[:destination_id])

    ship = current_user.current_ship
    can_travel = ship.can_travel_to?(destination)

    if can_travel == true
      ship.begin_travel_to(destination)

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

      trigger_success
    else
      trigger_failure can_travel
    end
  end

private
  def authorize
    raise 'You must be logged in' if current_user.nil?
  end
end
