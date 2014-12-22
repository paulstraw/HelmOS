class MapView extends tg.Base
  constructor: (@mainScreen) ->
    @mainScreen.el.html('')

    @panzoomed = false

    @el = $('<div id="map-view" class="view">')
    @el.append $("""
      <div id="map-content"></div>
    """)

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
    # snag the closest planet, along with a "nice" value to subtract from each planet's actual orbit
    closestPlanet = _.min tg.ghos.currentInfo.star.planets, (planet) -> planet.apogee
    planetSubVal = Math.log(closestPlanet.apogee) / Math.log(1.0001) * 0.9

    farthestPlanet = _.max tg.ghos.currentInfo.star.planets, (planet) -> planet.apogee + planet.perigee

    @el.find('#map-content').html JST['views/map-view'](star: tg.ghos.currentInfo.star, planetSubVal: planetSubVal)
    @mainScreen.el.append @el

    @el.find('#map-content').css
      width: Math.log(farthestPlanet.apogee) / Math.log(1.0001) - planetSubVal
      height: Math.log(farthestPlanet.apogee) / Math.log(1.0001) - planetSubVal

    if @panzoomed == false
      @el.find('#map-content').panzoom
        minScale: 0.01
        maxScale: 1
        transition: true
        increment: 0.02
        duration: 500

      @el.on 'mousewheel.focal', (e) =>
        e.preventDefault()

        delta = e.delta || e.originalEvent.wheelDelta
        zoomOut = if delta then delta < 0 else e.originalEvent.deltaY > 0

        @el.find('#map-content').panzoom 'zoom', zoomOut,
          increment: 0.1
          animate: false
          focal: e

      # @el.find('#map-content').panzoom 'zoom', 20
      @panzoomed = true




window.tg.MapView = MapView