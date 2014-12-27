class ConnectionLost
  constructor: ->
    $('body').html JST['views/connection-lost']()
    $('.reload').on 'click', -> window.location.reload()


window.tg.ConnectionLost = ConnectionLost