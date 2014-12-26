class MapView extends tg.Base
  # something like one of these could be kind of neat during travel
  # http://codepen.io/keithclark/pen/zqcEd
  # http://css-tricks.com/parallax-background-css3/
  # http://jsfiddle.net/ditman/8Ffrw/

  constructor: (@mainScreen) ->
    @mainScreen.el.html('')

    @zoomLevel = 1
    @panzoomed = false

    @el = $('<div id="map-view" class="view">')
    @el.append $("""
      <div class="starfield"></div>

      <div id="map-zoom-selector">
        <div class="trigger" data-zoom-level="2"></div>
        <div class="trigger current" data-zoom-level="1"></div>
      </div>
      <div id="map-content"></div>
    """)

    @starfield = new Starfield
    @starfield.initialize @el.find('.starfield')[0]
    @starfield.start()

    @mapContent = @el.find('#map-content')
    @mainScreen.el.append @el

    @_bindEvents()
    @render()

  _bindEvents: ->
    @el.on 'click', '#map-zoom-selector .trigger', (e) =>
      clicked = $(e.target)
      return if clicked.hasClass('current')

      clicked.siblings().removeClass('current')
      clicked.addClass('current')

      @zoomLevel = clicked.data('zoom-level')
      @render()

  render: ->
    # if @zoomLevel == 1
    #   @_renderZoomLevel1()
    # else
    #   @_renderZoomLevel2()

    closestPlanet = _.min tg.ghos.serverData.star.planets, (planet) -> planet.apogee
    planetSubVal = Math.log(closestPlanet.apogee) / Math.log(1.000015) * 0.95
    farthestPlanet = _.max tg.ghos.serverData.star.planets, (planet) -> planet.apogee

    @mapContent.html JST['views/map-view'](star: tg.ghos.serverData.star, planetSubVal: planetSubVal)
    @mapContent.find('.name').fitText(0.45)

    @mapContent.css
      width: (Math.log(farthestPlanet.apogee) / Math.log(1.000015) - planetSubVal) * 1.2 / 2
      height: (Math.log(farthestPlanet.apogee) / Math.log(1.000015) - planetSubVal) * 1.2 / 2


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
      onZoom: (e, zoomer, scale) =>
        if parseFloat(scale.toFixed(4)) > parseFloat(minScale.toFixed(4))
          scaleTo = 1
          @mapContent.find('.satellite').show()
        else
          scaleTo = Math.pow(1000000, (1 - scale + 1)) / 100000000000
          @mapContent.find('.satellite').hide()

        @mapContent.find('.planet').css
          transform: "scale(#{scaleTo})"


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
    offX = -(@mapContent.outerWidth() * 0.05 - $('#main-screen').outerWidth() / 2)
    offY = -(@mapContent.outerHeight() / 2 - $('#main-screen').outerHeight() / 2)
    @mapContent.panzoom('pan', offX, offY)

  # _renderZoomLevel1: ->
  #     # go home: paul.current_ship.update_attribute(:currently_orbiting_id, 3)
  #     closestSatellite = _.min tg.ghos.serverData.orbiting.satellites, (satellite) -> satellite.apogee
  #     satelliteSubVal = Math.log(closestSatellite.apogee) / Math.log(1.00015) * 0.9
  #     farthestSatellite = _.max tg.ghos.serverData.orbiting.satellites, (satellite) -> satellite.apogee + satellite.perigee

  #     @mapContent.html JST['views/map-view-zoom-1'](planet: tg.ghos.serverData.orbiting, satelliteSubVal: satelliteSubVal)

  #     @mapContent.css
  #       width: (Math.log(farthestSatellite.apogee) / Math.log(1.00015) - satelliteSubVal) * 1.2
  #       height: (Math.log(farthestSatellite.apogee) / Math.log(1.00015) - satelliteSubVal) * 1.2

  # _renderZoomLevel2: ->
  #   # snag the star's closest planet, along with a "nice" value to subtract from each planet's actual orbit
  #   closestPlanet = _.min tg.ghos.serverData.star.planets, (planet) -> planet.apogee
  #   planetSubVal = Math.log(closestPlanet.apogee) / Math.log(1.001) * 0.9
  #   farthestPlanet = _.max tg.ghos.serverData.star.planets, (planet) -> planet.apogee + planet.perigee

  #   @mapContent.html JST['views/map-view-zoom-2'](star: tg.ghos.serverData.star, planetSubVal: planetSubVal)

  #   @mapContent.css
  #     width: (Math.log(farthestPlanet.apogee) / Math.log(1.001) - planetSubVal) * 1.2
  #     height: (Math.log(farthestPlanet.apogee) / Math.log(1.001) - planetSubVal) * 1.2




window.tg.MapView = MapView