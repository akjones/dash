request = require 'request'
ciToken = require('../../credentials').ciCredentials.ciToken

jsonUri = (uri) ->
  uri.replace('http://', "http://ci:#{ciToken}@") + 'api/json?pretty=true'

deserialize = (queryString) ->
  deserializedParams = {}
  parts = queryString.split('&')
  for part in parts
    splitParts = part.split('=')
    deserializedParams[splitParts[0]] = splitParts[1]
  deserializedParams

exports.data = (error, success, params) ->
  projectUri = jsonUri deserialize(params).jobUrl

  request { url: projectUri, json: true }, (error, response, data) ->
    buildUri = jsonUri data.lastBuild.url

    request { url: buildUri, json: true }, (error, response, buildData) ->
      success {
        build: buildData.number
        status: if buildData.result is 'SUCCESS' then 'pass' else 'fail'
      }
