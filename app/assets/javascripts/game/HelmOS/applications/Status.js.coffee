class NavigationApplication extends tg.Application
  @applicationName: 'Navigation'

  @defaults:
    resizable: true
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
        <li><strong>Star:</strong> #{tg.ghos.serverData.star.name}</li>
        <li><strong>Orbiting:</strong> #{tg.ghos.serverData.orbiting.name}</li>
        <li><strong>Ships in orbit:</strong> #{tg.ghos.serverData.orbiting.connected_ships.length}</li>
      </ul>
    """


tg.NavigationApplication = NavigationApplication