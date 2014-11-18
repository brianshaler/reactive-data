Repository = require '../../src/Repository'

describe 'Repository key/value', ->

  beforeEach ->
    Repository.reset()

  it 'should retrieve the latest value for a key', ->
    key = 'kv1'
    Repository.update key, 1
    Repository.update key, 2
    Repository.getLatest(key).should.equal 2

  it 'should return null for new key', ->
    key = 'kv2'
    Should.not.exist Repository.getLatest key

  it 'should subscribe and call callback with latest value', ->
    key = 'kv3'
    values = []
    Repository.update key, 1
    Repository.subscribe key, (value) ->
      values.push value
    Repository.update key, 2
    values.length.should.equal 2
    values[0].should.equal 1
    values[1].should.equal 2
