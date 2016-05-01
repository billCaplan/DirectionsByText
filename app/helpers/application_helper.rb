require 'httparty'


module ApplicationHelper

  def processReply(body)
    breakdown = body.split("from")
    breakdown[1] = breakdown[1].split("to")
    breakdown = breakdown.flatten()
    return breakdown
  end


  def getDirections(breakdown)
    travelMode = ""


    case breakdown[0].downcase.strip()
    when "walking", "walk"
      travelMode = "walking"
    when "driving", "drive"
      travelMode = "driving"
    else
      travelMode = "walking"
    end
    # now the mode is set

    # here we have to remove spaces and commas, replacing them with +
    # split on commas, replace all spaces with +, rejoin
    temp = breakdown[1].split(",")
    temp.each do |slice|
      slice.tr!(' ', '+')
    end
    breakdown[1]=temp.join()

    temp = breakdown[2].split(",")
    temp.each do |slice|
      slice.tr!(' ', '+')
    end
    breakdown[2]=temp.join()
    breakdown[0] = travelMode
    return breakdown

  end

  def makeGoogleMapsAPICall(mode, origin, destination)

    origin = origin
    if origin[0] === "+"
      origin.slice!(0)
    end
    if origin[-1] === "+"
      origin.slice!(-1)
    end
    destination = destination
    if destination[0] === "+"
      destination.slice!(0)
    end
    if destination[-1] === "+"
      destination.slice!(-1)
    end

    mode = mode
    apiKey = ENV["google_maps_key"]


    url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{origin}&destination=#{destination}&mode=#{mode}&key=#{apiKey}"

    response = HTTParty.get(url)
    response.parsed_response

  end

  def createUseableDirections(response)
    finalString = [""]
    iterator = 0


    response['routes'][0]['legs'][0]['steps'].each do |step|
      if finalString[iterator].length >= 1500
        iterator += 1
        finalString[iterator] = ""
      end

      finalString[iterator] += "#{step['html_instructions']} \n"
      finalString[iterator] += "(#{step['duration']['text']}, #{step['distance']['text']} )\n"
      finalString[iterator] += "\n"

      finalString[iterator].gsub!(/(Destinatio)\w/, " Destination")

    end

    finalString[iterator] += "Total Time: #{response['routes'][0]['legs'][0]['duration']['text']}, #{response['routes'][0]['legs'][0]['distance']['text']}  \n"



    finalString.each_with_index do |piece, idx|
      finalString[idx] = ActionController::Base.helpers.strip_tags(piece)
    end

    return finalString
  end


end


# for create Useable directions this is an example leg ---
# {
#   "distance"=>{"text"=>"1.6 mi", "value"=>2589},
#   "duration"=>{"text"=>"35 mins", "value"=>2113},
#   "end_address"=>"850 Bush St, San Francisco, CA 94108, USA",
#   "end_location"=>{"lat"=>37.7898563, "lng"=>-122.4112993},
#   "start_address"=>"24 Willie Mays Plaza, San Francisco, CA 94107, USA",
#   "start_location"=>{"lat"=>37.7786388, "lng"=>-122.3909015},
#
#   "steps"=>[
#
#     {"distance"=>{"text"=>"331 ft", "value"=>101},
#     "duration"=>{"text"=>"1 min", "value"=>72},
#     "end_location"=>{"lat"=>37.7780083, "lng"=>-122.3917215},
#     "html_instructions"=>"Head <b>southwest</b> on <b>King St</b>/<b>Willie Mays Plaza</b> toward <b>3rd St</b>",
#     "polyline"=>{"points"=>"osqeFbn_jVZ`@x@jAf@t@"},
#     "start_location"=>{"lat"=>37.7786388, "lng"=>-122.3909015},
#     "travel_mode"=>"WALKING"},
#
#     {"distance"=>{"text"=>"0.9 mi", "value"=>1496},
#     "duration"=>{"text"=>"20 mins", "value"=>1186},
#     "end_location"=>{"lat"=>37.7876655, "lng"=>-122.4034605},
#     "html_instructions"=>"Turn <b>right</b> onto <b>3rd St</b>",
#     "maneuver"=>"turn-right",
#     "polyline"=>{"points"=>"qoqeFfs_jVOREDMNk@v@yApB_AnAe@l@[d@y@fAw@bAw@~@iA|AgA|Aq@|@uAjBUZCBEHCBA?U\\KLuAnBuApBcBxB}@lAMNe@j@]h@e@h@g@t@sAhBUXQR[b@UVW\\q@~@mA`BKJw@hAY`@aAtAk@x@IDEDEBC?A@C?e@FM@"},
#     "start_location"=>{"lat"=>37.7780083, "lng"=>-122.3917215},
#     "travel_mode"=>"WALKING"},
#
#     {"distance"=>{"text"=>"0.2 mi", "value"=>349},
#     "duration"=>{"text"=>"5 mins", "value"=>276},
#     "end_location"=>{"lat"=>37.7907632, "lng"=>-122.4040735},
#     "html_instructions"=>"Continue onto <b>Kearny St</b>",
#     "polyline"=>{"points"=>"}kseFr|ajVE@u@HcBTyANaBTsALwAPaBP"},
#     "start_location"=>{"lat"=>37.7876655, "lng"=>-122.4034605},
#     "travel_mode"=>"WALKING"},
#
#     {"distance"=>{"text"=>"0.4 mi", "value"=>643},
#     "duration"=>{"text"=>"10 mins", "value"=>579},
#     "end_location"=>{"lat"=>37.7898563, "lng"=>-122.4112993},
#     "html_instructions"=>"Turn <b>left</b> onto <b>Bush St</b><div style=\"font-size:0.9em\">Destination will be on the right</div>",
#     "maneuver"=>"turn-left",
#     "polyline"=>{"points"=>"g_teFl`bjVDv@BRFz@JtAJvALlCJ~AHdA?FF~@HfA@PPzC@L@Lf@xHRfD"},
#     "start_location"=>{"lat"=>37.7907632, "lng"=>-122.4040735},
#     "travel_mode"=>"WALKING"}],
#
#   "via_waypoint"=>[]
#   }
