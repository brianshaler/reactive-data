init = require './init'
Repository = require './Repository'

Stream = (individual = true) ->
  @items = []
  onItem = (itemOrItems) =>
    if individual
      @items.push itemOrItems
    else
      for item in itemOrItems
        @items.push item
    @update @items
  fn = if individual
    Repository.onItem
  else
    Repository.onItems
  @start = =>
    @stop = fn @filter, onItem
  @

module.exports = (options) ->
  Stream.call init options
