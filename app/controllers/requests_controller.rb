class RequestsController < ApplicationController
require 'twilio-ruby'


  def get_requests
    requests = Request.all
    render json: requests, status: 200, example_params: false
  end


  # This method captures the incoming sms message
  def request_incoming
    # And the message text
    @post_code = params[:Body]

    if @text.downcase != ''
      @twiml = Twilio::TwiML::Response.new do |r|
        r.Message "Hey we heard you - #{@post_code}"
      end

      # Respond to the message
      render xml: @twiml.text
    end
  end
end
