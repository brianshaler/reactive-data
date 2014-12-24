init = require './init'
Repository = require './Repository'

Item = ->
  @value = null unless @value?
  @save = (value) =>
    @Repository.update @key, value
  @start = =>
    @stop = @Repository.subscribe @key, (value) =>
      @value = value
      @update value
  @

module.exports = (options) ->
  Item.call init options
