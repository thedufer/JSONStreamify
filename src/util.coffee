module.exports.escapeForJSON = (str) ->
  JSON.stringify(str.toString()).slice(1, -1)
