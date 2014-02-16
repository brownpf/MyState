# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
  $(document).ready ->
    $("#postcode-row").hide()
    getLocation = ->
      if navigator.geolocation
        navigator.geolocation.getCurrentPosition showPosition
      else
        $("#postcode-row").show()

    showPosition = (position) ->
      $(".latitude").val(position.coords.latitude)
      $(".longitude").val(position.coords.longitude)

    getLocation()
