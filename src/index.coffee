Repository = require './Repository'

module.exports =
  Collection: require './Collection'
  Item: require './Item'
  Stream: require './Stream'

  update: Repository.update
  subscribe: Repository.subscribe
  get: Repository.get
  getStream: Repository.getStream
  getLatest: Repository.getLatest
  pushItem: Repository.pushItem
  pushItems: Repository.pushItems
  onItem: Repository.onItem
  onItems: Repository.onItems
  generateRepository: Repository.generateRepository
