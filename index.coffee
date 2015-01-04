{ Readable } = require('stream')
_ = require('underscore')

escapeForJSON = (str) ->
  JSON.stringify(str.toString()).slice(1, -1)

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

      stream.on 'data', (data) ->
        if stream instanceof JSONStream
          @push(data)
        else
          @push(escapeForJSON(data))

      stream.on 'end', ->
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

class ObjectStream extends JSONStream
  _startChar: "{"
  _endChar: "}"
  write: (key, data) ->
    if @finished
      throw new Error("Can't write to finished ObjectStream")
    if typeof data == "undefined"
      return
    @enqueue({ key, data })
  
  startItem: (item) ->
    @push("\"#{escapeForJSON(item.key)}\":")

class ArrayStream extends JSONStream
  _startChar: "["
  _endChar: "]"
  write: (data) ->
    if @finished
      throw new Error("Can't write to finished ArrayStream")
    if typeof data == "undefined"
      data = null
    @enqueue({ data })

  startItem: ->

module.exports = {
  ArrayStream
  ObjectStream
}
