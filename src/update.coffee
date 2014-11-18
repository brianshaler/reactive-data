module.exports = (value) ->
  for obj in @components
    if obj.stateKey
      {component, stateKey} = obj
      if component.setState
        state = {}
        state[stateKey] = value
        component.setState state
  if @listeners['update']?.length > 0
    for listener in @listeners['update']
      listener value
  @
