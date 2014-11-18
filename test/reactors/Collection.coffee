Repository = require '../../src/Repository'
Collection = require '../../src/Collection'

describe 'reactors/Collection', ->

  it 'should pass an item through when a collection is listening', ->
    name = 'Collection1'
    collection = Collection()
    collection.should.have.property 'items'
    Repository.pushItem
      name: name
      value: name
    collection.listen @component
    collection.items.length.should.equal 0
    Repository.pushItem
      name: name
      value: name
    collection.items.length.should.equal 1
    collection.unlisten @component
    Repository.pushItem
      name: name
      value: name
    collection.items.length.should.equal 1
    collection.listen @component
    Repository.pushItem
      name: name
      value: name
    collection.items.length.should.equal 2
    collection.unlisten @component

  it 'should update existing items', ->
    name = 'Collection2'
    collection = Collection
      identifier: 'name'
    collection.listen @component
    Repository.pushItems [
      {name: name, value: name}
      {name: name+'x', value: name}
      {name: name, value: name}
    ]
    collection.items.length.should.equal 2
    collection.unlisten @component

  it 'should filter and update existing items', ->
    name = 'Collection3'
    collection = Collection
      filter:
        name: name
      identifier: 'name'
    collection.listen @component
    Repository.pushItems [
      {name: name, value: name}
      {name: name+'x', value: name}
      {name: name, value: name}
    ]
    collection.items.length.should.equal 1
    collection.unlisten @component

  it 'should contain list of Items that can be updated by uid', ->
    name = 'Collection4'
    collection = Collection
      filter:
        name: name
      identifier: 'name'
    collection.listen @component
    Repository.pushItem
      name: name
      other: name
    Repository.update name,
      name: name
      other: name+'x'
    collection.items[0].value.other.should.equal name+'x'
    collection.unlisten @component

  it 'should use an identifier transform method as a unique key', ->
    name = 'Collection4'
    id = "id-#{name}"
    collection = Collection
      filter:
        name: name
      identifier: (item) -> item.stuff.id
    collection.listen @component
    Repository.pushItem
      name: name
      stuff:
        id: id
        val: 1
    collection.items[0].value.stuff.val.should.equal 1
    Repository.update id,
      name: name
      stuff:
        id: id
        val: 2
    obj = Repository.getLatest id
    collection.items[0].value.stuff.val.should.equal 2
    collection.unlisten @component
