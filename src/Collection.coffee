_ = require 'lodash'

init = require './init'
Repository = require './Repository'
Item = require './Item'

getId = (item, identifier) ->
  if typeof identifier is 'function'
    identifier item
  else
    item[identifier]

Collection = ->
  @items = []
  @start = =>
    @stop = Repository.onItems @filter, (objs) =>
      updated = false
      if @identifier
        toRemove = []
        objs = _.uniq objs, false, @identifier
        for newItem in objs
          newItemId = getId newItem, @identifier
          updateIndex = _.findIndex @items, (existingItem) =>
            getId(existingItem.value, @identifier) == newItemId
          if updateIndex != -1
            updated = true
            #_.remove objs, newItem
            toRemove.push newItem
            #@items[updateIndex] = Item key: newItemId
            Repository.update newItemId, newItem
        for newItem in toRemove
          _.remove objs, newItem
      else
        objs = _.filter objs, (item) =>
          found = _.find @items, (existingItem) =>
            existingItem == item
          !found
        objs = _.uniq objs
      for obj in objs
        objId = getId obj, @identifier
        item = Item key: objId
        item.listen {}
        @items.push item
        #@items.push obj
        Repository.update objId, obj
      return if objs.length == 0 and !updated
      @update @items
  @

module.exports = (options) ->
  Collection.call init options
