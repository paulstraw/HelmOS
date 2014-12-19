class HelmOS extends tg.Base
  constructor: ->
    console.log 'Booting HelmOS…'

    setTimeout @_boot, 0

  _boot: =>
    @applications = []

    # initialize the main menu
    @mainMenu = new tg.MainMenu

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