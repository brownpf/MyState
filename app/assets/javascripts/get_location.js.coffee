jQuery ($) ->
  getLocation = ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition showPosition
    else
      x.innerHTML = "Geolocation is not supported by this browser."

  showPosition = (position) ->
    $(".latitude").val(position.coords.latitude)
    $(".longitude").val(position.coords.longitude)


  $(".get-location").click ->
    getLocation()