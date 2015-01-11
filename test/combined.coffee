util = require('./util')
{ ArrayStream, ObjectStream } = require('../src/index')

describe 'object top-level', ->
  it 'nested array', (next) ->
    o = new ObjectStream()
    a = new ArrayStream()
    o.write('a', a)
    a.end()
    o.end()

    util.compareStreamObject(o, {a: []}, next)

  it 'alternate series nest', (next) ->
    o1 = new ObjectStream()
    a = new ArrayStream()
    o2 = new ObjectStream()
    o1.write('a', a)
    a.write(o2)
    o2.end()
    a.end()
    o1.end()

    util.compareStreamObject(o1, {a: [{}]}, next)

  it 'double series nest', (next) ->
    o1 = new ObjectStream()
    a1 = new ArrayStream()
    a2 = new ArrayStream()
    o1.write('a', a1)
    a1.write(a2)
    a2.end()
    a1.end()
    o1.end()

    util.compareStreamObject(o1, {a: [[]]}, next)

describe 'array top-level', ->
  it 'nested object', (next) ->
    a = new ArrayStream()
    o = new ObjectStream()
    a.write(o)
    o.end()
    a.end()

    util.compareStreamObject(a, [{}], next)

  it 'alternate series nest', (next) ->
    a1 = new ArrayStream()
    o = new ObjectStream()
    a2 = new ArrayStream()
    a1.write(o)
    o.write('a', a2)
    a2.end()
    o.end()
    a1.end()

    util.compareStreamObject(a1, [{a: []}], next)

  it 'double series nest', (next) ->
    a = new ArrayStream()
    o1 = new ObjectStream()
    o2 = new ObjectStream()
    a.write(o1)
    o1.write('a', o2)
    o2.end()
    o1.end()
    a.end()

    util.compareStreamObject(a, [{a: {}}], next)

describe 'bad streams', ->
  it 'doesn\'t chop up UTF-8 char in half', (next) ->
    b1 = Buffer([0x62, 0xe2])
    b2 = Buffer([0x80, 0x93, 0x61, 0x72])
    str = Buffer.concat([b1, b2]).toString()

    f = new require('stream').PassThrough()
    f.write(b1)
    f.write(b2)
    f.end()

    o = new ObjectStream()
    o.write("foo", f)
    o.end()

    util.compareStreamObject(o, foo: str, next)
