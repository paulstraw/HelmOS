class MainMenu extends tg.Base
  constructor: ->
    @el = $('#main-menu')

    @el.on 'click', '.link', @_openLink
    @el.on 'click', '.dropdown', @_toggleDropdown

  _openLink: (e) =>
    clicked = $(e.target)
    window.location = "#{window.location.protocol}//#{window.location.host}#{clicked.data('href')}"

  _toggleDropdown: (e) =>
    $(e.target).find('ul').toggleClass('open')


window.tg.MainMenu = MainMenu