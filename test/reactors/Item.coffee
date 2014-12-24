Repository = require '../../src/Repository'
Item = require '../../src/Item'

describe 'reactors/Item', ->

  it 'should listen on a component', ->
    key = 'key1'
    myVal = 'myVal'
    item = Item
      key: key
    item.listen @component, 'myState'
    Repository.update key,
      myVal: myVal
    @component.stateUpdated.should.equal true
    @component.should.have.property 'obj'
    @component.obj.should.have.property 'myState'
    @component.obj.myState.should.have.property 'myVal'
    @component.obj.myState.myVal.should.equal myVal
    item.should.have.property 'value'
    item.value.should.have.property 'myVal'
    item.value.myVal.should.equal myVal
    item.unlisten @component

  it 'should not update the wrong key', ->
    key = 'key2'
    value = 'value'
    item = Item
      key: key
    item.listen @component, 'myState'
    # one update, with initial value of undefined
    @component.stateUpdates.should.equal 1
    @component.obj.should.have.property 'myState'
    Should.not.exist @component.obj.myState
    Repository.update key+'x',
      value: value
    # still only one
    @component.stateUpdates.should.equal 1
    item.unlisten @component

  it 'should clobber on update', ->
    key = 'key3'
    item = Item
      key: key
    item.start()
    Repository.update key,
      stuff1: 'things1'
    item.value.stuff1.should.equal 'things1'
    Repository.update key,
      stuff2: 'things2'
    item.value.stuff2.should.equal 'things2'
    Should.not.exist item.value.stuff1
    item.stop()

  it 'should update all instances on .save(obj)', ->
    key = 'key4'
    item1 = Item
      key: key
    item1.start()
    item2 = Item
      key: key
    item2.start()
    item1.save
      stuff: 'things'
    item2.value.stuff.should.equal 'things'
    item1.stop()
    item2.stop()

  it 'should support isolated Repository instances', ->
    r1 = Repository.generateRepository()
    r2 = Repository.generateRepository()
    key = 'key5'
    item1 = Item
      key: key
      Repository: r1
    item1.start()
    item2 = Item
      key: key
      Repository: r2
    item2.start()
    item1.save
      stuff: 'things1'
    item2.save
      stuff: 'things2'
    item1.value.stuff.should.equal 'things1'
    item2.value.stuff.should.equal 'things2'
    item1.stop()
    item2.stop()
