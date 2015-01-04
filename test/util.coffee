_ = require('underscore')
util = exports
{ Readable } = require('stream')

util.consumeStream = (stream, next) ->
  str = ""
  stream.on 'data', (data) ->
    str += data
  stream.on 'error', (err) ->
    next(err ? 'an error event')
    next = ->
  stream.on 'end', ->
    next(null, str)
    next = ->

util.deepCompare = _.isEqual

util.compareStreamObject = (stream, obj, next) ->
  util.consumeStream stream, (err, str) ->
    if err?
      throw err
    util.deepCompare(obj, JSON.parse(str)).should.be.true;
    next()

class util.StringStream extends Readable
  constructor: (str) ->
    super()
    @push(str)
    @push(null)

  _read: (size) ->
