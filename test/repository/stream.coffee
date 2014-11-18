Repository = require '../../src/Repository'

describe 'Repository streams', ->

  beforeEach ->
    Repository.reset()

  it 'should emit items', ->
    name = 'RepositoryStream1'
    items = []
    stop = Repository.onItem null, (item) ->
      items.push item
    Repository.pushItem
      name: name
      value: 1
    items.length.should.equal 1
    items[0].value.should.equal 1
    stop()

  it 'should stop listening', ->
    name = 'RepositoryStream2'
    items = []
    stop = Repository.onItem null, (item) ->
      items.push item
    Repository.pushItem
      name: name
      value: 1
    items.length.should.equal 1
    stop()
    Repository.pushItem
      name: name
      value: 1
    items.length.should.equal 1

  it 'should filter', ->
    name = 'RepositoryStream3'
    items = []
    filter = (item) ->
      item.name == name
    stop = Repository.onItem filter, (item) ->
      items.push item
    Repository.pushItems [
      {name: name, value: 1}
      {name: name+'x', value: 1}
    ]
    items.length.should.equal 1
    Repository.pushItems [
      {name: name, value: 1}
      {name: name+'x', value: 1}
    ]
    stop()
    items.length.should.equal 2
