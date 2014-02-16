class Request < ActiveRecord::Base
  require 'twilio-ruby'

  def store_sms (body, from)
    if body.downcase != ''
      message = ''

      if body.length = 1
        req = Request.find_by(telephone: from)

        # Update that record
        store_status(body.to_i)

        #Set the message
        message = 'We have updated your status successfully'
      elsif is_postcode(body)
        # Call the Geo-location
        cord = Request.reverse_geolocation(body)

        # Store the Geo
        Request.store_coords(@cord[0],@cord[1])

        # Store the incomming number
        self.telephone = from

        #  build the return message
        message = 'We have located you, please send us a status update'
      else
        message ='We are not able to read your message - please check and try again?'
      end

      twiml = Twilio::TwiML::Response.new do |r|
        r.Message message
      end

      #return the for rendering
      twiml.text
    end
  end

  def self.is_postcode(code)
    regex = "^(GIR ?0AA|[A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]([0-9ABEHMNPRV-Y])?)|[0-9][A-HJKPS-UW]) ?[0-9][ABD-HJLNP-UW-Z]{2})$"
    pattern = Regexp.new(regex).freeze
    code =~ pattern
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
