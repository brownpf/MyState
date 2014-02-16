# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
  $(document).ready ->
    getLocation = ->
      if navigator.geolocation
        navigator.geolocation.getCurrentPosition showPosition
      else
        x.innerHTML = "Geolocation is not supported by this browser."

    showPosition = (position) ->
      $(".latitude").val(position.coords.latitude)
      $(".longitude").val(position.coords.longitude)

    getLocation()
