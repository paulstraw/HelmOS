class NavigationApplication extends tg.Application
  @applicationName: 'Navigation'
  @singleInstance: true

  @defaults:
    resizable: true
    singleInstance: true
    positioning:
      top: 0
      right: 0
      width: 200
      height: 120
      minWidth: 200
      minHeight: 100
      maxWidth: 300
      maxHeight: 500

  constructor: ->
    super

    @render()

  render: =>
    @contentEl.html """
      <ul>
        <li><span>Star:</span> #{tg.ghos.serverData.star.name}</li>
        <li><span>Orbiting:</span> #{tg.ghos.serverData.ship.currently_orbiting.name}</li>
        <li><span>Ships in orbit:</span> tg.ghos.serverData.ship.currently_orbiting.connected_ships.length</li>
      </ul>
    """


tg.NavigationApplication = NavigationApplication