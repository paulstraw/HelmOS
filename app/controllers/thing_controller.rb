class ThingController < WebsocketRails::BaseController
  def thingy
    # window.tg.ghos.socket.trigger('thing', 'hi', function() { console.log('success', arguments); }, function() { console.log('failure', arguments)})
    puts 'wowzers'
    puts current_user.inspect
    trigger_success 'dingus'
  end
end
