class HelmOS extends tg.Base
  constructor: ->
    console.log 'Booting HelmOS…'

    setTimeout @_boot, 0

  _boot: =>
    @applications = []

    # load our bootstrapped data from gon
    @currentInfo = {}
    @currentInfo.user = gon.current_user
    @currentInfo.ship = gon.current_ship
    @currentInfo.star = gon.current_star
    @currentInfo.orbiting = gon.currently_orbiting

    # set up our global websocket thingy
    @socket = new WebSocketRails("#{window.location.host}/websocket")

    # initialize the main menu
    @mainMenu = new tg.MainMenu

    # initialize the main screen
    @mainScreen = new tg.MainScreen

    this.on 'applicationLoaded', @_loadApplication
    this.on 'applicationClosed', @_closeApplication
    this.on 'applicationFocused', @_focusApplication

    new tg.Application

  _loadApplication: (application) =>
    @applications.push application

  _closeApplication: (applicationId) =>
    @applications = _.reject @applications, (application) ->
      application._id == applicationId

  _focusApplication: (application) =>
    _.each @applications, (app) -> app.unfocus()

window.tg.HelmOS = HelmOS