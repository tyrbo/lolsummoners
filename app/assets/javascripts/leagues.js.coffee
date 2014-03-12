$.fn.tipsy.defaults =
  delayIn: 0
  delayOut: 0
  fade: true
  fallback: ""
  gravity: "n"
  html: true
  live: false
  offset: 0
  opacity: 1
  title: "title"
  trigger: "hover"

$ ->
  $(".emblems").tipsy gravity: "s"
  $(".bestof").tipsy gravity: "s"
  $(".icon_ov").tipsy gravity: "s"
  $(".sp_lol").tipsy gravity: "s"

  $("tbody.by-rank:first").show()

  $(".dropdown-menu > li > a").click ->
    rank = $(this).text()
    $("tbody.by-rank").hide()
    $("tbody##{rank}").show()
    $("button#btn").html("#{rank} <span class=\"caret\"></span>")
    $("button#btn").dropdown("toggle")
    return false
