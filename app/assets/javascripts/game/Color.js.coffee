class Color
  @hex: (str) ->
    randomColor
      seed: str
      format: 'hex'
      luminosity: 'light'

  @rgba: (str, alpha) ->
    color = randomColor
      seed: str
      format: 'rgbArray'
      luminosity: 'light'

    "rgba(#{color[0]}, #{color[1]}, #{color[2]}, #{alpha})"

tg.Color = Color