class MapView extends tg.Base
  # something like one of these could be kind of neat during travel
  # http://codepen.io/keithclark/pen/zqcEd
  # http://css-tricks.com/parallax-background-css3/
  # http://jsfiddle.net/ditman/8Ffrw/

  constructor: (@mainScreen) ->
    @mainScreen.el.html('')

    @ships = []

    @panzoomed = false
    # this is sort of silly, but it basically "prevents clicking" on a planet/satellite after a drag
    @clickable = false

    @el = $('<div id="map-view" class="view">')
    @el.append $("""
      <div class="starfield"></div>
      <div id="travelling">
        <div class="title">Travelling</div>
        <p class="destination-container">Destination: <span class="destination"></span></p>
        <p class="arrival-container">Arrival In: <span class="arrival"></span></p>
      </div>
      <div id="map-content"></div>
    """)

    @starfield = new Starfield
    @starfield.initialize @el.find('.starfield')[0]
    @starfield.start()

    @mapContent = @el.find('#map-content')
    @travellingEl = @el.find('#travelling')
    @mainScreen.el.append @el

    @_bindEvents()
    @render()

    @enterTravelMode() if tg.ghos.serverData.ship.travelling

  _bindEvents: ->
    $(document).on 'ship.travel_started', @enterTravelMode
    $(document).on 'ship.travel_ended', @exitTravelMode
    $(document).on 'ship.added', (e, shipObj) =>
      @addShip shipObj
    $(document).on 'ship.removed', (e, shipObj) =>
      @removeShip shipObj

    @el.on 'mousedown touchstart', '.planet, .satellite', => @clickable = true
    @el.on 'mousemove touchmove', '.planet, .satellite', =>
      @clickable = false unless @clickable == false

    @el.on 'click', '.planet', (e) =>
      return unless @clickable

      tg.ghos.socket.trigger 'planets.info', {planet_id: $(e.currentTarget).data('id')}, (info) ->
        tg.ghos.launchApplication 'DetailsApplication', info
      , ->
        console.error 'Failed to get planet info', arguments

    @el.on 'click', '.satellite', (e) =>
      return unless @clickable

      tg.ghos.socket.trigger 'satellites.info', {satellite_id: $(e.currentTarget).data('id')}, (info) ->
        tg.ghos.launchApplication 'DetailsApplication', info
      , ->
        console.error 'Failed to get satellite info', arguments

  render: ->
    # go home: paul.current_ship.update_attribute(:currently_orbiting_id, 3)

    # closestPlanet = _.min tg.ghos.serverData.star.planets, (planet) -> planet.apogee
    planetSubVal = tg.ghos.serverData.planets[0].sub_val
    farthestPlanet = _.max tg.ghos.serverData.planets, (planet) -> planet.apogee

    @mapContent.html JST['views/map-view'](star: tg.ghos.serverData.star, planets: tg.ghos.serverData.planets, satellites: tg.ghos.serverData.satellites)
    @mapContent.find('.name').fitText(0.45)

    @mapContent.css
      width: (Math.log(farthestPlanet.apogee) / Math.log(1.00005) - planetSubVal) * 1.06 / 2
      height: (Math.log(farthestPlanet.apogee) / Math.log(1.00005) - planetSubVal) * 1.06 / 2


    if @panzoomed
      @mapContent.panzoom('resetDimensions')
      @mapContent.panzoom('resetPan')
      @mapContent.panzoom('resetZoom')
      @el.off 'mousewheel.focal'

    minScale = $('#main-screen').outerWidth() / @mapContent.outerWidth()
    @mapContent.panzoom
      minScale: minScale # 0.006, 0.003
      maxScale: 1
      transition: true
      increment: 0.03
      duration: 500
      contain: 'invert'


    @el.on 'mousewheel.focal', (e) =>
      e.preventDefault()

      delta = e.delta || e.originalEvent.wheelDelta
      zoomOut = if delta then delta < 0 else e.originalEvent.deltaY > 0

      @mapContent.panzoom 'zoom', zoomOut,
        increment: 0.03
        animate: false
        focal: e

    @panzoomed = true

    # center the map
    currentlyOrbiting = @mapContent.find('.currently-orbiting')

    offX = - parseInt(currentlyOrbiting.css('left')) + $('#main-screen').outerWidth() / 2
    offY = -(@mapContent.outerHeight() / 2 - $('#main-screen').outerHeight() / 2) - parseInt(currentlyOrbiting.css('margin-top'))
    @mapContent.panzoom 'pan', offX, offY

    @resetShips()
    @renderShips()


  resetShips: =>
    @removeShip mvShip.ship for mvShip in @ships

  renderShips: =>
    @addShip shipObj for shipObj in tg.ghos.serverData.ships


  addShip: (shipObj) =>
    existingShip = _.find @ships, (mvShip) -> mvShip.ship.id == shipObj.id

    unless existingShip
      ship = new tg.MapViewShip(shipObj)
      @ships.push ship
      @mapContent.append ship.el


  removeShip: (shipObj) =>
    existingShip = _.find @ships, (mvShip) -> mvShip.ship.id == shipObj.id
    existingShip.remove() if existingShip

    @ships = _.reject @ships, (mvShip) -> mvShip.ship.id == shipObj.id


  enterTravelMode: =>
    @mapContent.fadeOut 300, =>
      @travellingEl.fadeIn 150

      @starfield.minVelocity = 20
      @starfield.maxVelocity = 50
      @starfield.updateStarVelocities()

    @travellingEl.find('.destination').text tg.ghos.serverData.ship.travelling_to.name

    countdown = @travellingEl.find('.arrival').countdown(new Date(tg.ghos.serverData.ship.travel_ends_at))

    countdown.on 'update.countdown', (e) ->
      $(this).text e.strftime('%Mm %Ss')

    countdown.on 'finish.countdown', (e) ->
      $(this).text 'Arriving now…'

  exitTravelMode: =>
    @travellingEl.fadeOut 300, =>
      @mapContent.fadeIn 150

      @starfield.minVelocity = 0.1
      @starfield.maxVelocity = 3
      @starfield.updateStarVelocities()

      @render()


window.tg.MapView = MapView