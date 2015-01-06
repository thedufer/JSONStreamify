_ = require('underscore')

module.exports = makeJSONStream = (obj) ->
  if obj instanceof JSONStream
    obj
  else if _.isArray(obj)
    s = new ArrayStream()
    for i in obj
      s.write(i)
    s.end()
    s
  else if _.isObject(obj)
    s = new ObjectStream()
    for k, v of obj
      s.write(k, v)
    s.end()
    s
  else
    s = new PrimitiveStream(obj)
    s

JSONStream = require('./jsonStream')
ArrayStream = require('./arrayStream')
ObjectStream = require('./objectStream')
PrimitiveStream = require('./primitiveStream')
