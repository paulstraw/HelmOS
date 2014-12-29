class MapViewShip extends tg.Base
  constructor: (@ship) ->
    @el = $("""
      <div class="ship-container">
        <div class="continuous-rotation-wrapper">
          <div class="initial-rotation-wrapper">
            <div class="ship" data-id="#{@ship.id}"></div>
          </div>
        </div>
      </div>
    """)
    console.log 'mvShip constructor', @ship

    @el.css
      width: Math.log(@ship.currently_orbiting.radius * 2) * 70 + 128 + (64 * @ship.orbit_distance_multiplier)
      left: (Math.log(@ship.currently_orbiting.apogee) / Math.log(1.00005) - @ship.currently_orbiting.sub_val) / 2

    @el.find('.initial-rotation-wrapper').css
      transform: "rotate(#{@ship.name_degrees}deg)"

    @el.find('.continuous-rotation-wrapper').velocity
      rotateZ: 360
    ,
      loop: true
      easing: 'linear'
      duration: @ship.orbit_time_multiplier * 1000

  remove: =>
    console.log 'mvShip remove'
    @el.remove()
    @el = null



window.tg.MapViewShip = MapViewShip