$ ->
  region = $("#loading").data("region")
  name = $("#loading").data("name")

  timeout = setTimeout ( ->
    $("#loading").html("<h1>Uh oh.</h1><p>We took too long to find that player. Try again later.")
  ), 5000

  pusher = new Pusher "f1f712c95f23e54a53b0"
  channel = pusher.subscribe("search_#{region}_#{name}")

  channel.bind 'pusher:subscription_succeeded', ->
    jQuery.post("/api/search", { name: "#{name}", region: "#{region}" })
  
  channel.bind 'response', (data) ->
    clearTimeout timeout

    if data.status == 200
      window.location = "/players/#{region}/#{data.id}"
    else if data.status == 404
      $("#loading").html("<h1>Not Found. :(</h1>We couldn't find that player. Sorry.")
    else
      $("#loading").html("<h1>It broke.</h1><p>The Riot API may be unavailable. Try again later.")
