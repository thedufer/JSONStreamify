should = require('should')
util = require('./util')
{ ArrayStream, ObjectStream } = require('../js/index')

describe 'object top-level', ->
  it 'nested array', (next) ->
    o = new ObjectStream()
    a = new ArrayStream()
    o.write('a', a)
    a.finish()
    o.finish()

    util.compareStreamObject(o, {a: []}, next)

  it 'alternate series nest', (next) ->
    o1 = new ObjectStream()
    a = new ArrayStream()
    o2 = new ObjectStream()
    o1.write('a', a)
    a.write(o2)
    o2.finish()
    a.finish()
    o1.finish()

    util.compareStreamObject(o1, {a: [{}]}, next)

  it 'double series nest', (next) ->
    o1 = new ObjectStream()
    a1 = new ArrayStream()
    a2 = new ArrayStream()
    o1.write('a', a1)
    a1.write(a2)
    a2.finish()
    a1.finish()
    o1.finish()

    util.compareStreamObject(o1, {a: [[]]}, next)

describe 'array top-level', ->
  it 'nested object', (next) ->
    a = new ArrayStream()
    o = new ObjectStream()
    a.write(o)
    o.finish()
    a.finish()

    util.compareStreamObject(a, [{}], next)

  it 'alternate series nest', (next) ->
    a1 = new ArrayStream()
    o = new ObjectStream()
    a2 = new ArrayStream()
    a1.write(o)
    o.write('a', a2)
    a2.finish()
    o.finish()
    a1.finish()

    util.compareStreamObject(a1, [{a: []}], next)

  it 'double series nest', (next) ->
    a = new ArrayStream()
    o1 = new ObjectStream()
    o2 = new ObjectStream()
    a.write(o1)
    o1.write('a', o2)
    o2.finish()
    o1.finish()
    a.finish()

    util.compareStreamObject(a, [{a: {}}], next)
