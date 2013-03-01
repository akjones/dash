exports.get = (req, res) ->
    res.writeHead 200, {'Content-Type', 'application/json'}
    res.write JSON.stringify loadWidgets(), null, '\t'
    res.end()

loadWidgets = ->
    require '../data/all-widgets'
