# this is pretty much an abstract class
class Application extends tg.Base
  @applicationName: 'Application'

  @defaults:
    resizable: true
    positioning:
      top: 0
      left: 0
      width: 180
      height: 124
      minWidth: 180
      minHeight: 124
      maxWidth: 640
      maxHeight: 480

  constructor: ->
    @_id = _.uniqueId()
    @_loadSettings()
    @_buildElement()

    @focused = false
    @acceptsMouseInput = true

    tg.ghos.trigger 'applicationLoaded', this

  getId: =>
    @_id

  getName: =>
    @constructor.applicationName

  _buildElement: ->
    @el = $("""<div class="application #{@constructor.applicationName.toLowerCase().split(' ').join('-')}" data-application-id="#{@_id}">""")
    @el.append $("""
      <div class="title-bar">
        <h1>#{@getName()}</h1>

        <ul class="window-controls">
          <li class="close">Close</li>
        </ul>
      </div>

      <div class="application-content"></div>
    """)

    @contentEl = @el.find('.application-content')

    # append the resize handle, if appropriate
    if @settings.resizable
      @el.append('<div class="application-resizer ui-resizable-handle ui-resizable-se"></div>')

    # insert the element into the DOM
    $('#application-container').append @el

    # set up drag things
    @el.draggable
      handle: '.title-bar'
      containment: 'parent'

    # set up resize things
    if @settings.resizable
      @el.resizable
        handles:
          se: '.application-resizer'
        containment: 'parent'

    # handle mousedown events (just for focusing atm)
    @el.on 'mousedown', @_handleMouseDown

    # handle mouseup events (just for focusing atm)
    @el.on 'mouseup', @_handleMouseUp

    # handle close button click
    @el.on 'click', '.window-controls .close', =>
      console.log 'close' if @acceptsMouseInput

    # position the window based on positioning settings
    @_positionWindow()

    # finally, focus ourselves
    @focus()

  _positionWindow: ->
    containerWidth = $('#application-container').outerWidth()
    containerHeight = $('#application-container').outerHeight()

    left = 0
    top = 0
    width = @settings.positioning.width
    height = @settings.positioning.height
    minWidth = @settings.positioning.minWidth
    minHeight = @settings.positioning.minHeight
    maxWidth = @settings.positioning.maxWidth
    maxHeight = @settings.positioning.maxHeight

    if @settings.positioning.top?
      top = @settings.positioning.top
    else if @settings.positioning.bottom?
      top = containerHeight - height - @settings.positioning.bottom

    if @settings.positioning.left?
      left = @settings.positioning.left
    else if @settings.positioning.right?
      left = containerWidth - width - @settings.positioning.right

    @el.css
      left: left
      top: top
      width: width
      height: height
      minWidth: minWidth
      minHeight: minHeight
      maxWidth: maxWidth
      maxHeight: maxHeight


  _loadSettings: ->
    if window.gon && gon["application_#{@getName()}_settings"]
      @settings = _.extend @constructor.defaults, gon["application_#{@getName()}_settings"]
    else
      @settings = @constructor.defaults

  _handleMouseUp: (e) =>
    setTimeout =>
      @acceptsMouseInput = true
    , 0

  _handleMouseDown: (e) =>
    unless @focused
      @acceptsMouseInput = false

      @focus()
      e.preventDefault()
      e.stopPropagation()

  close: ->
    tg.ghos.trigger 'applicationClosed', @_id

  focus: ->
    tg.ghos.trigger 'applicationFocused', this
    @focused = true
    @el.css 'z-index', 3

  unfocus: =>
    @focused = false
    @el.css 'z-index', 2



tg.Application = Application