module.exports = (component, stateKey) ->
  @components.push
    component: component
    stateKey: stateKey
  if @components.length == 1
    if @start and !@started
      @started = true
      @start()
  @
