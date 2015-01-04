    npm install jsonstreamify

Example:

    obj = new ObjectStream()

    arr = new ArrayStream()
    arr.write(1)
    arr.write('strings')
    arr.write(true)
    arr.write(undefined)
    arr.finish()

    obj.write('nesting arrays in objects', arr)

    obj.finish()
    
    obj.pipe(process.stdout)

    // outputs `{"nesting arrays in objects":[1,"strings",true,null]}`

- `ObjectStream`
  - `write(key, value)`
  - `finish()`
- `ArrayStream`
  - `write(value)`
  - `finish()`

The constructors take no arguments.

##ObjectStream

###ObjectStream::write(key, value)

Adds a key/value pair to the object.  The key will be stringified.  Value types
are discussed below.

Note: The stream will contain keys in the order they are written to the object.

###ObjectStream::finish()

Declares that no more will be written.  It is an error to call `write` after
`finish`.  After finish is called and all of the values resolve, the stream
will end.

##ArrayStream

###ArrayStream::write(value)

Appends a value to the array.  Arrays can only be written to in order.  Value
types are discussed below.

###ArrayStream::finish()

Declares that no more will be written.  It is an error to call `write` after
`finish`.  After finish is called and all of the values resolve, the stream
will end.

##Values

###Streams

Instances of `Readable` will be consumed and the output `toString`'d and
appropriately escaped.  This will probably not do what you want if the data
provided isn't Strings or Buffers.

Instances of ObjectStream and ArrayStream are an exception - they will not be
`toString`'d or escaped, so nesting them will work as you'd expect.

###undefined

`undefined` doesn't exist in JSON, so we handle it the same way as
`JSON.stringify` - it will be changed to `null` if in an array, and the
key/value pair will be dropped if it is the value in an object.

###Everything Else

All other values will be `JSON.stringify`'d.  That means that objects, strings,
arrays, booleans, numbers, null, etc. will behave as expected.

##Buffering

Written streams will be left paused until it's time to pipe them out.  This
makes it safe to write in any order/timing without filling memory.
