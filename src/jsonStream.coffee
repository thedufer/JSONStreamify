Promise = require('bluebird')
{ Readable } = require('stream')
util = require('./util')

class JSONStream extends Readable
  constructor: (obj) ->
    super
    @push(@_startChar)
    @_hasContents = false
    @_promise = Promise.resolve()

  isFinished: ->
    return !@_promise?

  _read: ->

  _consume: (item) ->
    if !@_hasContents
      @_hasContents = true
    else
      @push(",")

    @startItem(item)

    if item.data instanceof Readable
      stream = item.data
    else
      stream = makeJSONStream(item.data)

    isJSON = stream instanceof JSONStream
    p = new Promise (resolve, reject) =>
      if !isJSON
        @push('"')

      stream.on 'data', (data) =>
        if isJSON
          @push(data)
        else
          @push(util.escapeForJSON(data))

      stream.on 'end', =>
        if !isJSON
          @push('"')
        resolve()
    return p

  _finish: ->
    @push(@_endChar)
    @push(null)

  end: ->
    if @isFinished()
      throw new Error("Can't call end on a finished JSONStream")
    @_promise = @_promise.then(=> @_finish()).done()

  enqueue: (item) ->
    @_promise = @_promise.then(=> @_consume(item))

module.exports = JSONStream

makeJSONStream = require('./makeJsonStream')
