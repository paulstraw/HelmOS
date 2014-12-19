class Base
  on: (event, handler) ->
    @_events ?= {}
    (@_events[event] ?= []).push handler
    this

  off: (event, handler) ->
    for suspect, index in @_events[event] when suspect is handler
      @_events[event].splice index, 1
    this

  trigger: (event, args...) ->
    return this unless @_events[event]?
    handler.apply this, args for handler in @_events[event]
    this

window.tg.Base = Base