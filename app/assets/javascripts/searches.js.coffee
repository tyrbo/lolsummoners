$ ->
  region = $('#loading').data('region')
  name = $('#loading').data('name')

  socket = new WebSocket "ws://#{window.location.host}/queue/#{region}/#{name}"

  socket.onmessage = (event) ->
    if event.data.length
      if event.data.indexOf('done') != -1
        split = event.data.split(' ')
        window.location = "/players/#{region}/#{split[1]}"
      else if event.data == 'fail'
        alert('Something went wrong.')
        socket.close()
