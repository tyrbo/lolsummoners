$ ->
  region = $('#loading').data('region')
  name = $('#loading').data('name')

  timeout = setTimeout ( ->
    socket.close()
    $('#loading').html('<h1>Uh oh.</h1><p>We took too long to find that player. Try again later.')
  ), 5000

  socket = new WebSocket "ws://#{window.location.host}/queue/#{region}/#{name}?by=name"

  socket.onmessage = (event) ->
    clearTimeout timeout
    if event.data.length
      split = event.data.split(' ')
      if split[0] == 'done'
        clearTimeout(timeout)
        window.location = "/players/#{region}/#{split[1]}"
      else if split[0] == 'fail'
        clearTimeout(timeout)
        if split[1] == '404'
          $('#loading').html('<h1>Not found. :(</h1><p>We couldn\'t find that player. Sorry.')
        else
          $('#loading').html('<h1>It broke.</h1><p>The Riot API may be unavailable. Try again later.')
        socket.close()
