Promise = require('bluebird')
{ Readable } = require('stream')
util = require('./util')

class JSONStream extends Readable
  constructor: ->
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
    else
      @push(JSON.stringify(item.data))
      return

  _finish: ->
    @push(@_endChar)
    @push(null)

  end: ->
    @_promise = @_promise.then(=> @_finish()).done()

  enqueue: (item) ->
    @_promise = @_promise.then(=> @_consume(item))

module.exports = JSONStream
