class DetailsApplication extends tg.Application
  # @applicationName: 'Navigation'
  @singleInstance: false
  @appClassNames: 'details'

  @defaults:
    resizable: true
    positioning:
      top: 0
      left: 0
      width: 200
      height: 133
      minWidth: 200
      minHeight: 133
      maxWidth: 300
      maxHeight: 500

  constructor: (@props) ->
    # TODO honestly, i'm not sure if changing a class variable like this will screw anything up.
    # it seems to be working fine, but it'd be nice to find a "cleaner" way.
    @constructor.applicationName = @props.name
    super

    if @props.travel_time?
      travelMinutes = ~~(@props.travel_time / 60)
      travelSeconds = ~~(@props.travel_time % 60)

      @travelTime = ''
      @travelTime += "#{travelMinutes}m " if travelMinutes > 0
      @travelTime += "#{travelSeconds}s" if travelSeconds > 0

    @el.on 'click', '.travel', =>
      tg.ghos.socket.trigger(
        'ships.begin_travel',
        {destination_class: @props.class_name, destination_id: @props.id},
        =>
          @close()
        ,
        (failureReason) ->
          alert("Can't travel there: #{failureReason}")
      )



    @render()

  render: =>
    @contentEl.html """
      <ul></ul>

      <button class="travel button">Travel</button>
    """

    @contentEl.find('ul').append "<li><span>Travel Time:</span> #{@travelTime}</li>" if @travelTime
    @contentEl.find('ul').append "<li><span>Ships in Orbit:</span> #{@props.connected_ships.length}</li>"


tg.DetailsApplication = DetailsApplication