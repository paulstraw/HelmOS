class ServerData extends tg.Base
  constructor: ->
    # load our bootstrapped data from gon
    @user = gon.current_user
    @ship = gon.current_ship
    @star = gon.current_star
    @orbiting = gon.currently_orbiting

    # make sure the object we're orbiting has a ships array, and we're in it
    @orbiting.connected_ships ||= []
    shipIncluded = _.find(@orbiting.connected_ships, (ship) => ship.id == @ship.id)
    @orbiting.connected_ships.push @ship unless shipIncluded

    @_subscribeToChannels()

  _subscribeToChannels: ->
    @_orbiting_channel = tg.ghos.socket.subscribe @orbiting.channel_name

    @_orbiting_channel.bind 'ship_arrived', (ship) ->
      console.log 'ship arrived', ship

    @_orbiting_channel.bind 'ship_departed', (ship) ->
      console.log 'ship departed', ship


window.tg.ServerData = ServerData
