class HelmOS extends tg.Base
  constructor: ->
    console.log 'Booting HelmOS…'

    setTimeout @_boot, 0

  _boot: =>
    @applications = []

    # set up our global websocket thingy
    @socket = new WebSocketRails("#{window.location.host}/websocket")

    # set up an instance of ServerData
    @serverData = new tg.ServerData

    # initialize the main menu
    @mainMenu = new tg.MainMenu

    # initialize the main screen
    @mainScreen = new tg.MainScreen

    this.on 'applicationLoaded', @_loadApplication
    this.on 'applicationClosed', @_closeApplication
    this.on 'applicationFocused', @_focusApplication

    new tg.CommunicationsApplication

  _loadApplication: (application) =>
    @applications.push application

  _closeApplication: (applicationId) =>
    @applications = _.reject @applications, (application) ->
      application._id == applicationId

  _focusApplication: (application) =>
    _.each @applications, (app) -> app.unfocus()

window.tg.HelmOS = HelmOS