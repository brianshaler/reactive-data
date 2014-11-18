_ = require 'lodash'
Bacon = require 'baconjs'
Bacon = Bacon.Bacon if Bacon.Bacon # what. the. fuck.

keyval = {}
KVStream = new Bacon.Bus()
ItemStream = new Bacon.Bus()

Repository =
  reset: ->
    keyval = {}

  update: (key, value) ->
    keyval[key] = value
    KVStream.push
      key: key
      value: _.clone value
    return

  subscribe: (name, cb) ->
    {stream, latest} = Repository.get name
    cb latest# if latest
    stream.onValue cb

  getStream: (key) ->
    KVStream
    .filter (item) -> item.key == key
    .map (item) -> item.value

  getLatest: (key) ->
    _.clone keyval[key]

  get: (key) ->
    stream: Repository.getStream key
    latest: Repository.getLatest key

  pushItem: (obj) ->
    Repository.pushItems [obj]

  pushItems: (objs) ->
    ItemStream.push objs

  onItem: (filter = (-> true), cb) ->
    stop = Repository.onItems filter, (items) ->
      for item in items
        cb item
    stop

  onItems: (filter, cb) ->
    bus = new Bacon.Bus()
    unsubscribeStream = ItemStream.onValue (newItems) ->
      items = if typeof filter is 'function'
        _.filter newItems, filter
      else
        _.filter newItems, (item) ->
          unless (_.where [item], filter).length == 1
            return false
          true
      return unless items.length > 0
      bus.push items
    unsubscribeBus = bus.onValue cb
    ->
      unsubscribeStream()
      unsubscribeBus()

module.exports = Repository
