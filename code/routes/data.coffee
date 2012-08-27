request = require 'request'

hudson = (callback) ->
    projectUri = 'http://ci.jenkins-ci.org/job/jenkins_pom/api/json?pretty=true'
    request {url: projectUri, json: true}, (error, response, data) ->
        buildUri = data.lastBuild.url + 'api/json?pretty=true'
        request {url: buildUri, json: true}, (error, response, buildData) ->
            callback {
                number: buildData.number
                result: buildData.result
            }

teamCity = (callback) ->
    buildUri = 'http://teamcity.jetbrains.com/guestAuth/app/rest/builds/buildType:bt343'
    request.get {url: buildUri, json: true}, (error, response, data) ->
        callback {
            number: data.number
            result: data.status            
        }

sonarCoverage = (callback) ->
    uri = 'https://sonar.springsource.org/api/resources?resource=org.springframework.integration:spring-integration&metrics=coverage'
    request.get {url: uri, json: true}, (error, response, data) ->
        callback {
            value: Math.floor data[0].msr[0].val   
        }

exports.test = (req, res) ->
    switch req.params.type
        when 'ping'
            sys = require 'sys'
            exec = require('child_process').exec
            exec 'ping -c 3 google.com', (error, stdout, stderr) ->
                packetsRegex = /(\d+) packets transmitted, (\d+) packets received/
                matches = packetsRegex.exec stdout
                res.writeHead 200, {'Content-Type', 'application/json'}
                if matches[1] == matches[2]
                    res.write '{"status":"pass"}'
                else
                    res.write '{"status":"fail"}'
                res.end()
        when 'hudson-build-status'
            res.writeHead 200, {'Content-Type', 'application/json'}
            hudson (data) ->
                status = if data.result is 'SUCCESS' then "pass" else "fail"
                res.write '{"build":"' + data.number + '", "status":"' + status + '"}'
                res.end()
        when 'teamcity-build-status'
            res.writeHead 200, {'Content-Type', 'application/json'}
            teamCity (data) ->
                status = if data.result is 'SUCCESS' then "pass" else "fail"
                res.write '{"build":"' + data.number + '", "status":"' + status + '"}'
                res.end()
        when 'sonar-code-coverage'
            res.writeHead 200, {'Content-Type', 'application/json'}
            sonarCoverage (data) ->
                res.write '{"value":"' + data.value + '"}'
                res.end()
        when 'countdown'
            res.writeHead 200, {'Content-Type', 'application/json'}
            res.write '{"days":5}'
            res.end()
        else
            res.writeHead 404, {'Content-Type', 'text/html'}
            res.write 'Not supported'
            res.end()

exports.get = exports.test
