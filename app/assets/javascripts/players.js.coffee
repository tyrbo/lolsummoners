$ ->
  region = $('#update-value').data('region')
  name = $('#update-value').data('name')
  updating = $('#update-value').data('update')

  if updating == true
    socket = new WebSocket "ws://#{window.location.host}/queue/#{region}/#{name}"

    socket.onmessage = (event) ->
      if event.data.length
        split = event.data.split(' ')
        if split[0] == 'done'
          humane.notice('This player has been updated. The page will reload in 3 seconds.')
          setTimeout (->
            window.location.reload(true)
          ), 3000
        else if split[0] == 'fail'
          if split[1] != '404'
            humane.error('The Riot API is unavailable. We were unable to update this player.')
          socket.close()
