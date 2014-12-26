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


  render: ->
    # go home: paul.current_ship.update_attribute(:currently_orbiting_id, 3)

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


window.tg.MapView = MapView