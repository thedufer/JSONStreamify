replacements = {
  0: '\\u0000'
  1: '\\u0001'
  2: '\\u0002'
  3: '\\u0003'
  4: '\\u0004'
  5: '\\u0005'
  6: '\\u0006'
  7: '\\u0007'
  8: '\\b'
  9: '\\t'
  10: '\\n'
  11: '\\u000b'
  12: '\\f'
  13: '\\r'
  14: '\\u000e'
  15: '\\u000f'
  16: '\\u0010'
  17: '\\u0011'
  18: '\\u0012'
  19: '\\u0013'
  20: '\\u0014'
  21: '\\u0015'
  22: '\\u0016'
  23: '\\u0017'
  24: '\\u0018'
  25: '\\u0019'
  26: '\\u001a'
  27: '\\u001b'
  28: '\\u001c'
  29: '\\u001d'
  30: '\\u001e'
  31: '\\u001f'
  34: '\\\"'
  92: '\\\\'
}

bufReplacements = {}

for byte, str of replacements
  bufReplacements[byte] = new Buffer(str)

module.exports = escapeBuffer = (buf) ->
  extraBytes = 0
  needsReplacement = []
  for byte, ix in buf
    if byte of bufReplacements
      extraBytes += bufReplacements[byte].length - 1
      needsReplacement.push(ix)
  out = new Buffer(buf.length + extraBytes)
  ixRead = 0
  ixWrite = 0
  for ixReplace in needsReplacement
    if ixReplace > ixRead
      buf.copy(out, ixWrite, ixRead, ixReplace)
      ixWrite += ixReplace - ixRead
    replaceBuf = bufReplacements[buf[ixReplace]]
    replaceBuf.copy(out, ixWrite)
    ixWrite += replaceBuf.length
    ixRead = ixReplace + 1

  buf.copy(out, ixWrite, ixRead)

  out
