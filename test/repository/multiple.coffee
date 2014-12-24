Repository = require '../../src/Repository'

describe 'Multiple Repository instances', ->

  it 'should maintain independent instances', ->
    r1 = Repository.generateRepository()
    r2 = Repository.generateRepository()
    key = 'kv1'
    r1.update key, 1
    r2.update key, 2
    r1.getLatest(key).should.equal 1
    r2.getLatest(key).should.equal 2
