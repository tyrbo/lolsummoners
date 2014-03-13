$ ->
  region = $('#loading').data('region')
  name = $('#loading').data('name')

  socket = new WebSocket "ws://#{window.location.host}/queue/#{region}/#{name}"

  socket.onmessage = (event) ->
    if event.data.length
      if event.data.indexOf('done') != -1
        split = event.data.split(' ')
        window.location = "/players/#{region}/#{split[1]}"
      else if event.data.indexOf('fail') != -1
        if event.data.indexOf('404') != -1
          $('#loading').html('<h1>Not found. :(</h1><p>We couldn\'t find that player. Sorry.')
        else
          $('#loading').html('<h1>It broke.</h1><p>The Riot API is unavailable. Try again later.')
        socket.close()
