class MainMenu extends tg.Base
  constructor: ->
    @el = $('#main-menu')

    @el.on 'click', '.link', @_openLink
    @el.on 'click', '.dropdown', @_toggleDropdown
    @el.on 'click', '.application', @_launchApplication

  _openLink: (e) =>
    clicked = $(e.target)
    window.location = "#{window.location.protocol}//#{window.location.host}#{clicked.data('href')}"

  _toggleDropdown: (e) =>
    $(e.target).find('ul').toggleClass('open')

  _launchApplication: (e) =>
    clicked = $(e.target)
    tg.ghos.launchApplication clicked.data('application-class')
    clicked.closest('.dropdown').trigger 'click'


window.tg.MainMenu = MainMenu