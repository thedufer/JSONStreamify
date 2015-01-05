expect = require('chai').expect
util = require('./util')
{ ArrayStream } = require('../src/index')

describe 'simple arrays', ->
  it 'empty', (next) ->
    a = new ArrayStream()
    a.end()

    util.compareStreamObject(a, [], next)

  it 'number', (next) ->
    a = new ArrayStream()
    a.write(1234)
    a.end()

    util.compareStreamObject(a, [1234], next)

  it 'null', (next) ->
    a = new ArrayStream()
    a.write(null)
    a.end()

    util.compareStreamObject(a, [null], next)

  it 'undefined', (next) ->
    a = new ArrayStream()
    a.write(undefined)
    a.end()

    util.compareStreamObject(a, [null], next)

  describe 'bool', ->
    it 'true', (next) ->
      a = new ArrayStream()
      a.write(true)
      a.end()

      util.compareStreamObject(a, [true], next)

    it 'false', (next) ->
      a = new ArrayStream()
      a.write(false)
      a.end()

      util.compareStreamObject(a, [false], next)

  it 'string w/ weird characters', (next) ->
    a = new ArrayStream()
    value = '\n\r\0\\"'
    a.write(value)
    a.end()

    util.compareStreamObject(a, [value], next)

  it 'stream', (next) ->
    a = new ArrayStream()
    value = 'this is a good length for a string'
    a.write(new util.StringStream(value))
    a.end()

    util.compareStreamObject(a, [value], next)

describe 'nested arrays', ->
  it 'single nest', (next) ->
    a1 = new ArrayStream()
    a2 = new ArrayStream()
    a1.write(a2)
    a1.end()
    a2.end()

    util.compareStreamObject(a1, [[]], next)

  it 'parallel nest', (next) ->
    a1 = new ArrayStream()
    a2 = new ArrayStream()
    a3 = new ArrayStream()
    a1.write(a2)
    a1.write(a3)
    a1.end()
    a3.end()
    a2.end()

    util.compareStreamObject(a1, [[], []], next)

  it 'series nest', (next) ->
    a1 = new ArrayStream()
    a2 = new ArrayStream()
    a3 = new ArrayStream()
    a1.write(a2)
    a2.write(a3)
    a1.end()
    a3.end()
    a2.end()

    util.compareStreamObject(a1, [[[]]], next)

describe 'write', ->
  it 'returns itself', (next) ->
    a = new ArrayStream()
    a.write(1).write(2)
    a.end()

    util.compareStreamObject(a, [1, 2], next)

describe 'write', ->
  it 'errors after end', ->
    a = new ArrayStream()
    a.end()
    expect(->
      a.write('a')
    ).to.throw(Error)
