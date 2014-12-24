class Socket::MessagesController < WebsocketRails::BaseController
  before_action :authorize

  def create
    ship = current_user.current_ship

    # check if the user is allowed to a message to this channel
    authorized = false

    # StarSystem.Sol:Faction.United Republic -> ['StarSystem.Sol', 'Faction.United Republic']
    channel_model_instances = message[:channel_name].split(':').map do |channel_segment|
      # StarSystem.Sol -> ['StarSystem', 'Sol']
      split_channel_segment = channel_segment.split('.')

      # 'StarSystem' -> StarSystem
      channel_segment_class = Object.const_get split_channel_segment[0]

      # StarSystem.find_by(name: 'Sol')
      channel_segment_class.find_by(name: split_channel_segment[1])
    end

    if channel_model_instances.count == 2 && channel_model_instances.first.is_a?(StarSystem) && channel_model_instances.last.is_a?(Faction)
      # StarSystem.Sol:Faction.United Republic
      if ship.star_system == channel_model_instances.first && ship.faction == channel_model_instances.last
        authorized = true
      end
    elsif channel_model_instances.count == 1 && channel_model_instances.first.is_a?(Faction)
      # Faction.United Republic
      if ship.faction == channel_model_instances.first
        authorized = true
      end
    end

    if authorized
      msg = Message.new
      msg.ship = ship
      msg.content = message[:content]
      msg.channel_name = message[:channel_name]

      msg.save!


      # notify channel subscribers of the new message
      WebsocketRails[message[:channel_name]].trigger(:new_message, msg.as_json(
        include: {
          ship: {
            methods: [:name_hex_color]
          }
        }
      ))

      # let the client that sent this message know it was successful
      trigger_success
    else
      trigger_failure
    end
  end

private
  def authorize
    raise 'You must be logged in' if current_user.nil?
  end
end
