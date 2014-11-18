Repository = require '../../src/Repository'
Stream = require '../../src/Stream'

describe 'reactors/Stream', ->

  it 'should pass an item through when a component is listening', ->
    name = 'Stream1'
    stream = Stream()
    stream.should.have.property 'items'
    Repository.pushItem
      name: name
      value: name
    stream.listen @component
    stream.items.length.should.equal 0
    Repository.pushItem
      name: name
      value: name
    stream.items.length.should.equal 1
    stream.unlisten @component
    Repository.pushItem
      name: name
      value: name
    stream.items.length.should.equal 1
    stream.listen @component
    Repository.pushItem
      name: name
      value: name
    stream.items.length.should.equal 2
    stream.unlisten @component

  it 'should pass filtered items through', ->
    name = 'Stream2'
    filter = (item) ->
      item.name == name
    stream = Stream
      filter: filter
      stateKey: 'state'
    stream.listen @component
    Repository.pushItem
      name: name
      value: name
    Repository.pushItem
      name: name+'x'
      value: name
    stream.unlisten @component

  it 'should update state with each item', ->
    name = 'Stream3'
    stream = Stream()
    stream.listen @component, 'myState'
    Repository.pushItems [
      {name: name, value: name}
      {name: name+'x', value: name}
      {name: name, value: name}
    ]
    @component.stateUpdates.should.equal 3
    stream.unlisten @component

  it 'should update state with each filtered item', ->
    name = 'Stream3'
    stream = Stream
      filter:
        name: name
    stream.listen @component, 'myState'
    Repository.pushItems [
      {name: name, value: name}
      {name: name+'x', value: name}
      {name: name, value: name}
    ]
    @component.stateUpdates.should.equal 2
    stream.unlisten @component
