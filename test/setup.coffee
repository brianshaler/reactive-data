global.Should = require 'should'

beforeEach ->
  component =
    stateUpdated: false
    stateUpdates: 0
    setState: (obj) ->
      component.stateUpdates++
      component.obj = obj
      component.stateUpdated = true
  @component = component
