$(document).ready ->
  return unless $('body').is '.home.index'

  @starfield = new Starfield
  @starfield.initialize $('.starfield')[0]
  @starfield.start()