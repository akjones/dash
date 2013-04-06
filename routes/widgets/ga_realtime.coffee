phantom = require 'node-phantom'

uri = 'https://accounts.google.com/ServiceLogin?service=analytics&continue=https://www.google.com/analytics/web/?hl%3Den%23realtime%2Frt-overview%2Fa2555375w4652622p4788737%2F&followup=https://www.google.com/analytics/web/?hl%3Den%23realtime%2Frt-overview%2Fa2555375w4652622p4788737%2F'

exports.data = (error, response) ->
    phantom.create (err, ph) ->
      ph.createPage (err, page) ->
        page.set('settings', {
          userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.97 Safari/537.11"
          javascriptEnabled: true
          loadImages: false
        })

        page.onConsoleMessage = (msg) -> console.log(msg)
        page.onError = (msg, trace) ->
          page.render('tmp/error.png')
          console.log(msg)
          trace.forEach (item) ->
            console.log('  ', item.file, ':', item.line)
            ph.exit()
        page.onLoadFinished = (status) ->
          if status != "success"
            console.log("Unable to access network")
          else
            page.injectJs('../../credentials.json')

        page.open uri, ->
          logIn page
          setTimeout ->
            getStats page, (res) ->
              response {
                visitors: res
              }
              ph.exit()
          , 10000
    , {parameters:{'config':'phantom_config.json'}}


getStats = (page, cb) ->
  page.evaluate ->
    { current_visitors: document.getElementById('ID-overviewCounterValue').innerText }
  , (err, res) ->
    if err
      console.log(err)
    else
      cb(res.current_visitors)

logIn = (page) ->
  page.evaluate ->
    form = document.getElementById('gaia_loginform')
    form.Email.value = googleAnalyticsCredentials.username
    form.Passwd.value = googleAnalyticsCredentials.password
    form.submit()

  , (err, res) ->
    if err
      console.log(err)
