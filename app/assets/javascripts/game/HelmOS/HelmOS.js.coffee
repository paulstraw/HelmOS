class HelmOS extends tg.Base
  constructor: ->
    console.log 'Booting HelmOS…'

    setTimeout @_boot, 0

  _boot: =>
    @applications = []

    # set up our global websocket thingy
    @socket = new WebSocketRails("#{window.location.host}/websocket")

    @socket.bind 'connection_closed', -> new tg.ConnectionLost

    @socket.on_open = =>
      # set up an instance of ServerData
      @serverData = new tg.ServerData

  completeBoot: =>
    # initialize the main menu
    @mainMenu = new tg.MainMenu

    # initialize the main screen
    @mainScreen = new tg.MainScreen

    this.on 'applicationLoaded', @_loadApplication
    this.on 'applicationClosed', @_closeApplication
    this.on 'applicationFocused', @_focusApplication

    new tg.CommunicationsApplication
    new tg.NavigationApplication

  launchApplication: (applicationClass, arg1, arg2, arg3, arg4) =>
    if tg[applicationClass].singleInstance
      alreadyOpen = _.find(@applications, (application) -> application.constructor.name == applicationClass)

      return if alreadyOpen

    # TODO this argument thing is really bad and doesn't scale
    new tg[applicationClass](arg1, arg2, arg3, arg4)

  _loadApplication: (application) =>
    @applications.push application

  _closeApplication: (applicationId) =>
    @applications = _.reject @applications, (application) ->
      application._id == applicationId

  _focusApplication: (application) =>
    _.each @applications, (app) -> app.unfocus()

window.tg.HelmOS = HelmOS