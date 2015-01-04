JSONStream = require('./jsonStream')
util = require('./util')

class ObjectStream extends JSONStream
  _startChar: "{"
  _endChar: "}"
  write: (key, data) ->
    if @finished
      throw new Error("Can't write to finished ObjectStream")
    if typeof data == "undefined"
      return
    @enqueue({ key, data })

    @
  
  startItem: (item) ->
    @push("\"#{util.escapeForJSON(item.key)}\":")

module.exports = ObjectStream
