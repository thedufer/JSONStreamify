expect = require('chai').expect
stringifyBuffer = require('../src/stringifyBuffer')

describe 'ascii', ->
  it 'all characters', ->
    buf = new Buffer(128)
    for i in [0...128]
      buf[i] = i

    goodStr = JSON.stringify(buf.toString()).slice(1, -1)

    testStr = stringifyBuffer(buf).toString()

    expect(testStr).to.equal(goodStr)
