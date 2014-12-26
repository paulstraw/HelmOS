class Socket::MessagesController < WebsocketRails::BaseController
  before_action :authorize

  def create
    ship = current_user.current_ship
    authorized = ship.authorized_for_channel? message[:channel_name]

    if authorized
      msg = Message.new
      msg.ship = ship
      msg.content = message[:content]
      msg.channel_name = message[:channel_name]

      msg.save!

      # notify channel subscribers of the new message
      WebsocketRails[message[:channel_name]].trigger(:new_message, msg.as_json(
        include: [:ship]
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
