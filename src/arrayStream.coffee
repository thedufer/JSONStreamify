JSONStream = require('./jsonStream')

class ArrayStream extends JSONStream
  _startChar: "["
  _endChar: "]"
  write: (data) ->
    if @isFinished()
      throw new Error("Can't write to a finished ArrayStream")
    if typeof data == "undefined"
      data = null
    @enqueue({ data })

    @

  startItem: ->

module.exports = ArrayStream
