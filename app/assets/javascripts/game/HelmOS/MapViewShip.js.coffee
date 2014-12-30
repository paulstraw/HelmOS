class MapViewShip extends tg.Base
  constructor: (@ship) ->
    @orbitable = if @ship.currently_orbiting_type == 'Planet'
      _.find tg.ghos.serverData.planets, (planet) => planet.id == @ship.currently_orbiting_id
    else if @ship.currently_orbiting_type == 'Satellite'
      _.find tg.ghos.serverData.satellites, (satellite) => satellite.id == @ship.currently_orbiting_id

    @el = $("""
      <div class="ship-container">
        <div class="continuous-rotation-wrapper">
          <div class="initial-rotation-wrapper">
            <div class="ship" data-id="#{@ship.id}"></div>
          </div>
        </div>
      </div>
    """)

    @el.find('.ship').addClass 'current' if @ship.id == tg.ghos.serverData.ship.id
    console.log 'mvShip constructor', @ship

    @el.css
      width: Math.log(@orbitable.radius * 2) * 70 + 128 + (64 * @ship.orbit_distance_multiplier)
      left: (Math.log(@orbitable.apogee) / Math.log(1.00005) - @orbitable.sub_val) / 2

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