class MainScreen extends tg.Base
  constructor: ->
    @el = $('#main-screen')

    # tg.ghos.currentInfo
    @currentView = new tg.MapView(this)



window.tg.MainScreen = MainScreen