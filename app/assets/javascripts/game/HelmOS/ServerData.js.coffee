class ServerData extends tg.Base
  constructor: ->
    # load our bootstrapped data from gon
    @user = gon.current_user
    @ship = gon.current_ship
    @star = gon.current_star
    @orbiting = gon.currently_orbiting
    @currentChannels = []

    # make sure the object we're orbiting has a ships array, and we're in it
    @orbiting.connected_ships ||= []
    shipIncluded = _.find(@orbiting.connected_ships, (ship) => ship.id == @ship.id)
    @orbiting.connected_ships.push @ship unless shipIncluded

    @_subscribeToChannels()
    @_bindShipEvents()

  _subscribeToChannels: ->
    @_orbitingChannel = tg.ghos.socket.subscribe @orbiting.channel_name

    @_orbitingChannel.bind 'ship_arrived', (ship) ->
      console.log 'ship arrived', ship

    @_orbitingChannel.bind 'ship_departed', (ship) ->
      console.log 'ship departed', ship

    _.each @ship.current_channel_names, (channelName) =>
      channel = tg.ghos.socket.subscribe_private channelName, =>
        $(document).trigger 'channel.connected', [channelName]
        @currentChannels.push channel
      , =>
        console.error "Error connecting to channel #{channelName}", arguments

      channel.bind 'new_message', (data) ->
        $(document).trigger "#{data.channel_name.replace(' ', '_')}.new_message", [data]

  _bindShipEvents: ->
    tg.ghos.socket.bind 'travel_started', (ship) =>
      return unless ship.id == @ship.id

      @ship = ship
      $(document).trigger('ship.travel_started')

    tg.ghos.socket.bind 'travel_ended', (ship) =>
      return unless ship.id == @ship.id

      @ship = ship
      $(document).trigger('ship.travel_ended')


window.tg.ServerData = ServerData
