$ ->
  region = $('#update-value').data('region')
  name = $('#update-value').data('name')
  updating = $('#update-value').data('update')

  if updating == true
    timeout = setTimeout ( ->
      humane.error('We were unable to update the player at this time.')
    ), 5000

    pusher = new Pusher "f1f712c95f23e54a53b0"
    channel = pusher.subscribe("player_#{region}_#{name}")

    channel.bind 'pusher:subscription_succeeded', ->
      jQuery.post("/api/update", { summoner_id: "#{name}", region: "#{region}" })

    channel.bind 'response', (data) ->
      clearTimeout timeout

      if data.status == 200
        humane.notice('This player has been updated. The page will reload in 3 seconds.')
        clearTimeout(timeout)
        setTimeout (->
          window.location.reload(true)
        ), 3000
      else if data.status != 404
        humane.error('The Riot API is unavailable. We were unable to update this player.')
