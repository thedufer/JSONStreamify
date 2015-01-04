{ Readable } = require('stream')
util = require('./util')

class JSONStream extends Readable
  constructor: ->
    super
    @push(@_startChar)
    @_hasContents = false
    @_queue = []
    @_reading = false
    @finished = false

  _read: ->

  _attemptConsume: ->
    if @_reading
      return

    if @_queue.length == 0
      if @finished
        @push(@_endChar)
        @push(null)
      return

    item = @_queue.shift()

    if !@_hasContents
      @_hasContents = true
    else
      @push(",")

    @startItem(item)

    if item.data instanceof Readable
      @_reading = true

      stream = item.data
      isJSON = stream instanceof JSONStream

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
        @_reading = false
        @_attemptConsume()
    else
      @push(JSON.stringify(item.data))
      @_attemptConsume()

  finish: ->
    @finished = true
    @_attemptConsume()

  enqueue: (item) ->
    @_queue.push(item)
    @_attemptConsume()

module.exports = JSONStream
