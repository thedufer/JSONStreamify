JSONStream = require('./jsonStream')
Promise = require('bluebird')

class PrimitiveStream extends JSONStream
  constructor: (obj) ->
    super
    @enqueue(obj)
    @end()

  _startChar: ""
  _endChar: ""
  write: (data) ->
    throw new Error("Can't write to a PrimitiveStream")

  _consume: (item) ->
    @push(JSON.stringify(item))
    return Promise.resolve()

module.exports = PrimitiveStream
