class MainMenu extends tg.Base
  constructor: ->
    @el = $('#main-menu')

    @el.on 'click', '.link', (e) =>
      clicked = $(e.target)
      window.location = "#{window.location.protocol}//#{window.location.host}#{clicked.data('href')}"


window.tg.MainMenu = MainMenu