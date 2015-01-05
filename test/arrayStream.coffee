should = require('should')
util = require('./util')
{ ArrayStream } = require('../js/index')

describe 'simple arrays', ->
  it 'empty', (next) ->
    a = new ArrayStream()
    a.finish()

    util.compareStreamObject(a, [], next)

  it 'number', (next) ->
    a = new ArrayStream()
    a.write(1234)
    a.finish()

    util.compareStreamObject(a, [1234], next)

  it 'null', (next) ->
    a = new ArrayStream()
    a.write(null)
    a.finish()

    util.compareStreamObject(a, [null], next)

  it 'undefined', (next) ->
    a = new ArrayStream()
    a.write(undefined)
    a.finish()

    util.compareStreamObject(a, [null], next)

  describe 'bool', ->
    it 'true', (next) ->
      a = new ArrayStream()
      a.write(true)
      a.finish()

      util.compareStreamObject(a, [true], next)

    it 'false', (next) ->
      a = new ArrayStream()
      a.write(false)
      a.finish()

      util.compareStreamObject(a, [false], next)

  it 'string w/ weird characters', (next) ->
    a = new ArrayStream()
    value = '\n\r\0\\"'
    a.write(value)
    a.finish()

    util.compareStreamObject(a, [value], next)

  it 'stream', (next) ->
    a = new ArrayStream()
    value = 'this is a good length for a string'
    a.write(new util.StringStream(value))
    a.finish()

    util.compareStreamObject(a, [value], next)

describe 'nested arrays', ->
  it 'single nest', (next) ->
    a1 = new ArrayStream()
    a2 = new ArrayStream()
    a1.write(a2)
    a1.finish()
    a2.finish()

    util.compareStreamObject(a1, [[]], next)

  it 'parallel nest', (next) ->
    a1 = new ArrayStream()
    a2 = new ArrayStream()
    a3 = new ArrayStream()
    a1.write(a2)
    a1.write(a3)
    a1.finish()
    a3.finish()
    a2.finish()

    util.compareStreamObject(a1, [[], []], next)

  it 'series nest', (next) ->
    a1 = new ArrayStream()
    a2 = new ArrayStream()
    a3 = new ArrayStream()
    a1.write(a2)
    a2.write(a3)
    a1.finish()
    a3.finish()
    a2.finish()

    util.compareStreamObject(a1, [[[]]], next)

describe 'chaining', ->
  it 'works', (next) ->
    a = new ArrayStream()
    a.write(1).write(2)
    a.finish()

    util.compareStreamObject(a, [1, 2], next)
