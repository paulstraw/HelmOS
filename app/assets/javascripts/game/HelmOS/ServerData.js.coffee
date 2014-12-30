class ServerData extends tg.Base
  constructor: ->
    # load our bootstrapped data from gon
    @user = gon.current_user
    @ships = []
    @currentChannels = []

    # make sure the object we're orbiting has a ships array, and we're in it
    # @orbiting.connected_ships ||= []
    # shipIncluded = _.find(@orbiting.connected_ships, (ship) => ship.id == @ship.id)
    # @orbiting.connected_ships.push @ship unless shipIncluded
    @_loadBootstrapData()


  _bindGlobalEvents: ->
    @_systemChannel = tg.ghos.socket.subscribe @starSystem.channel_name

    @_systemChannel.bind 'ship_arrived', @addShip
    @_systemChannel.bind 'ship_departed', @removeShip


  _loadBootstrapData: ->
    # if we don't pass some kind of value (empty string, in this case), the response doesn't come back properly
    tg.ghos.socket.trigger 'bootstrap.data', '', (bootstrapData) =>
      @ship = bootstrapData.current_ship
      @_bindShipEvents()
      @_subscribeToChatChannels()

      @planets = bootstrapData.planets
      @satellites = bootstrapData.satellites
      @star = bootstrapData.star
      @starSystem = bootstrapData.star_system
      @_bindGlobalEvents()

      @addShip ship for ship in bootstrapData.ships


      tg.ghos.completeBoot()
    , ->
      console.error 'Problem loading bootstrap data', arguments
      new tg.ConnectionLost


  addShip: (shipToAdd) =>
    @removeShip(shipToAdd) # this is weird, but is here to prevent duplicates
    @ships.push shipToAdd
    $(document).trigger 'ship.added', [shipToAdd]

  removeShip: (shipToRemove) =>
    @ships = _.reject @ships, (ship) => ship.id == shipToRemove.id
    $(document).trigger 'ship.removed', [shipToRemove]


  _subscribeToChatChannels: ->
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
