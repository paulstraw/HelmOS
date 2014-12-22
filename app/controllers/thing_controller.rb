class ThingController < WebsocketRails::BaseController
  before_action :authorize

  def thingy
    # window.tg.ghos.socket.trigger('thing', 'hi', function() { console.log('success', arguments); }, function() { console.log('failure', arguments)})
    puts 'wowzers'
    puts current_user.inspect
    trigger_success 'dingus'
  end

private
  def authorize
    raise 'You must be logged in' if current_user.nil?
  end
end
