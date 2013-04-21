request = require 'request'
ciToken = require('../../credentials').ciCredentials.ciToken

jsonUri = (uri) ->
  uri.replace('http://', "http://ci:#{ciToken}@") + 'api/json?pretty=true'

exports.data = (error, success) ->
  projectUri = jsonUri "http://ci.getup.org.au:8080/job/tijuana_build_flow/"

  request { url: projectUri, json: true }, (error, response, data) ->
    buildUri = jsonUri data.lastBuild.url

    request { url: buildUri, json: true }, (error, response, buildData) ->
      success {
        build: buildData.number
        status: if buildData.result is 'SUCCESS' then 'pass' else 'fail'
      }
