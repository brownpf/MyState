class Request < ActiveRecord::Base

  def store_sms (body)
    if @text.downcase != ''

      # Call the Geo-location
      cord = Request.reverse_geolocation(body)

      # Store the Geo
      Request.store(@cord[0],@cord[1])

      twiml = Twilio::TwiML::Response.new do |r|
        r.Message "Hey, we heard you - #{@post_code}"
      end

      twiml.text
    end
  end

  def postcode?
    POSTCODE = "^(GIR ?0AA|[A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]([0-9ABEHMNPRV-Y])?)|[0-9][A-HJKPS-UW]) ?[0-9][ABD-HJLNP-UW-Z]{2})$"

  end

  def reverse_geolocation(postcode)
    api_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{URI.encode(postcode)}&key=AIzaSyDFNZW_WcnVprGhOTWBDIPYsqCvLB9KHoE&sensor=false"

    # Grab the response
    res = HTTParty.get(api_url)

    # Grab the lat and long
    #puts res["results"][0]["geometry"]["location"]["lat"]
    lat = res["results"][0]["geometry"]["location"]["lat"]
    lon = res["results"][0]["geometry"]["location"]["lng"]

    [lat,lon]
  end

  def store_coords(x_coords, y_coords)
    self.x_coords = x_coords
    self.y_coords = y_coords
    self.save
  end

  def store_status(status)
    self.status = status
    self.save
  end
end
