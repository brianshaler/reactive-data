Repository = require '../../src/Repository'
unlisten = require '../../src/unlisten'

describe 'common/unlisten', ->

  it 'should call stop() only after the last listener unlistens', ->
    stopCalls = 0
    component1 = {n: 1}
    component2 = {n: 2}
    obj =
      components: [
        {component: component1}
        {component: component2}
      ]
      started: true
      stop: ->
        stopCalls++
    unlisten.apply obj, [component1]
    obj.components.length.should.equal 1
    stopCalls.should.equal 0
    unlisten.apply obj, [component2]
    stopCalls.should.equal 1
