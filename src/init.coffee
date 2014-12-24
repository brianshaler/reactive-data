_ = require 'lodash'

Repository = require './Repository'
listen = require './listen'
unlisten = require './unlisten'
update = require './update'

module.exports = (options) ->
  reactor =
    Repository: options?.Repository ? Repository
    components: []
    listen: ->
      listen.apply reactor, arguments
    unlisten: ->
      unlisten.apply reactor, arguments
    update: ->
      update.apply reactor, arguments
    listeners: {}
    on: (eventName, cb) ->
      unless reactor.listeners[eventName]?.length > 0
        reactor.listeners[eventName] = []
      reactor.listeners[eventName].push cb
      reactor
    off: (eventName, cb) ->
      return unless reactor.listeners[eventName]?.length > 0
      for i in [reactor.listeners[eventName].length-1..0] by -1
        if reactor.listeners[eventName][i] == cb
          reactor.listeners[eventName].splice i, 1
      reactor
  _.merge reactor, options
  reactor
