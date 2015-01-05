expect = require('chai').expect
util = require('./util')
{ ObjectStream } = require('../src/index')

describe 'simple objects', ->
  it 'empty', (next) ->
    o = new ObjectStream()
    o.end()

    util.compareStreamObject(o, {}, next)

  it 'number key', (next) ->
    o = new ObjectStream()
    o.write(1, '')
    o.end()

    util.compareStreamObject(o, {1: ''}, next)

  it 'number value', (next) ->
    o = new ObjectStream()
    o.write('a', 1234)
    o.end()

    util.compareStreamObject(o, {a: 1234}, next)

  it 'null value', (next) ->
    o = new ObjectStream()
    o.write('a', null)
    o.end()

    util.compareStreamObject(o, {a: null}, next)

  it 'undefined value', (next) ->
    o = new ObjectStream()
    o.write('a', undefined)
    o.end()

    util.compareStreamObject(o, {}, next)

  describe 'bool value', ->
    it 'true', (next) ->
      o = new ObjectStream()
      o.write('a', true)
      o.end()

      util.compareStreamObject(o, {a: true}, next)

    it 'false', (next) ->
      o = new ObjectStream()
      o.write('a', false)
      o.end()

      util.compareStreamObject(o, {a: false}, next)

  it 'string value w/ weird characters', (next) ->
    o = new ObjectStream()
    value = '\n\r\0\\"'
    o.write('a', value)
    o.end()

    util.compareStreamObject(o, {a: value}, next)

  it 'stream value', (next) ->
    o = new ObjectStream()
    value = 'this is a good length for a string'
    o.write('a', new util.StringStream(value))
    o.end()

    util.compareStreamObject(o, {a: value}, next)

describe 'nested objects', ->
  it 'single nest', (next) ->
    o1 = new ObjectStream()
    o2 = new ObjectStream()
    o1.write('a', o2)
    o1.end()
    o2.end()

    util.compareStreamObject(o1, {a: {}}, next)

  it 'parallel nest', (next) ->
    o1 = new ObjectStream()
    o2 = new ObjectStream()
    o3 = new ObjectStream()
    o1.write('a', o2)
    o1.write('b', o3)
    o1.end()
    o3.end()
    o2.end()

    util.compareStreamObject(o1, {a: {}, b: {}}, next)

  it 'series nest', (next) ->
    o1 = new ObjectStream()
    o2 = new ObjectStream()
    o3 = new ObjectStream()
    o1.write('a', o2)
    o2.write('a', o3)
    o1.end()
    o3.end()
    o2.end()

    util.compareStreamObject(o1, {a: {a: {}}}, next)

describe 'chaining', ->
  it 'works', (next) ->
    o = new ObjectStream()
    o.write('a', 1).write('b', 2)
    o.end()

    util.compareStreamObject(o, {a: 1, b: 2}, next)

describe 'write', ->
  it 'errors after end', ->
    a = new ObjectStream()
    a.end()
    expect(->
      a.write('a')
    ).to.throw(Error)
