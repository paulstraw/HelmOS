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
    @el.find('#map-content').html JST['views/map-view'](star: tg.ghos.currentInfo.star)
    @mainScreen.el.append @el

    if @panzoomed == false
      @el.find('#map-content').panzoom
        minScale: 0.02
        maxScale: 1
        transition: true
        increment: 0.05
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