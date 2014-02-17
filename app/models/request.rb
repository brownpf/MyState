class Request < ActiveRecord::Base
  # Capture the pattern
  POSTCODE_REGEX = "^(GIR ?0AA|[A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]([0-9ABEHMNPRV-Y])?)|[0-9][A-HJKPS-UW]) ?[0-9][ABD-HJLNP-UW-Z]{2})$"

  require 'twilio-ruby'

  # Instance method to capture the incoming SMS
  def store_sms (body, from)
    # If the body isn't empty
    if body.strip != ''
      message = ''

      # Work out if it is a postcode
      if body.length == 1
        req = self.class.find_by(telephone: from)

        # Update that record
        store_status(body.to_i)

        #Set the message
        message = 'We have updated your status successfully'
      elsif self.class.valid_postcode?(body)
        # Store the postcode
        self.postcode = body

        # Call the Geo-location
        cord = self.reverse_geolocation(body)

        # Store the Geo
        self.store_coords(cord[:lat],cord[:lon])

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

  # Do a geo-location reverse look-up on PostCode
  def reverse_geolocation(postcode)
    # API URL for google geo
    api_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{URI.encode(postcode)}&key=AIzaSyDFNZW_WcnVprGhOTWBDIPYsqCvLB9KHoE&sensor=false"

    # Grab the response
    res = HTTParty.get(api_url)

    # Grab the lat and long from the JSON response
    lat = res["results"][0]["geometry"]["location"]["lat"]
    lon = res["results"][0]["geometry"]["location"]["lng"]

    # Return the results to the calling method
    {lat: lat,lon: lon}
  end

  # Instance method which saves the lat and long co-ordinates
  def store_coords(x_coords, y_coords)
    self.latitude = x_coords
    self.longitude = y_coords
    self.save
  end

  # Instance method which stores the status from an incomming request
  def store_status(status)
    self.status = status
    self.save
  end

  # Class method to validate the postcode passed in the body of the message
  def self.valid_postcode?(code)
    # Now load it for comparison
    pattern = Regexp.new(POSTCODE_REGEX).freeze

    # If its a match, then the postcode is valid, otherwise not
    (code.upcase =~ pattern).nil? ? false:true
  end
end
