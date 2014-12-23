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

  def authorize_private_channel
    channel = WebsocketRails[message[:channel]]
    ship = current_user.current_ship


    split_channel_name = message[:channel].split('-')
    channel_class = Object.const_get split_channel_name[0]
    channel_model_instance = channel_class.find(split_channel_name[1])

    authorized = false

    if channel_class == StarSystem
      authorized = true if ship.star_system == channel_model_instance
    elsif channel_class == Faction
      authorized = true if ship.faction == channel_model_instance
    end

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
