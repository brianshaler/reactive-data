_ = require 'lodash'

module.exports = (component) ->
  for i in [@components.length-1..0] by -1
    if @components[i].component == component
      @components.splice i, 1
  if @components.length == 0
    @stop() if @stop
    @started = false
    @stop = null
  @
