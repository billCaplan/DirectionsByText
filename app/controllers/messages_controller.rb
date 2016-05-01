class MessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token
#skip_before_filter :authenticate_user!, :only => "reply"
include ApplicationHelper

 def reply
   message_body = params["Body"]
   from_number = params["From"]

   breakdown = processReply(message_body)

   urlReadyInfo = getDirections(breakdown)

   finalJSON = makeGoogleMapsAPICall(urlReadyInfo[0],urlReadyInfo[1],urlReadyInfo[2])


   finalString = createUseableDirections(finalJSON)



  #   NEED TO BREAK THIS INTO A SEPERATE FUNCTION, SPLIT MESSAGES GREATER THAN 1600 AND CALL MESSAGES CREATE ON
  #   THE WHOLE (MAYBE ARRAY) SO SEND AS MANY MESSAGES AS I WANT JUST IN 1600 <= CHUNKS
  #   VVVVVV doesnt work, it splits every new line so a million messages get sent, need to do as I parse the JSON
    # chunks = finalString.scan(/.{1,1600}/)

   boot_twilio
  #  REDEFINE CHUNK ON THIS PAGE SOMEWHERE
   finalString.each do |chunk|

     sms = @client.messages.create(
      #  from: Rails.application.secrets.twilio_number,
        from: '+14123654698',
       to: from_number,
       body: "#{chunk}"
     )
    end


 end

 private

 def boot_twilio
   account_sid = ENV["twilio_sid"]


   auth_token = ENV["twilio_token"]

   @client = Twilio::REST::Client.new account_sid, auth_token
 end
end
