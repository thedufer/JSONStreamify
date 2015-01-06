JSONStream = require('./jsonStream')
util = require('./util')

class ObjectStream extends JSONStream
  _startChar: "{"
  _endChar: "}"
  write: (key, data) ->
    if @isFinished()
      throw new Error("Can't write to a finished ObjectStream")
    if typeof data == "undefined"
      return
    @enqueue({ key, data })

    @

  startItem: (item) ->
    @push("\"#{util.escapeForJSON(item.key)}\":")

module.exports = ObjectStream
