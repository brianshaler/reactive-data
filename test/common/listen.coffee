Repository = require '../../src/Repository'
listen = require '../../src/listen'

describe 'common/listen', ->

  it 'should call start for only the first listener', ->
    startCalls = 0
    obj =
      components: ['x']
      started: false
      start: ->
        startCalls++
        obj.started = true
    listen.apply obj, {}
    startCalls.should.equal 0
    obj.components = []
    listen.apply obj, {}
    startCalls.should.equal 1
    listen.apply obj, {}
    startCalls.should.equal 1
