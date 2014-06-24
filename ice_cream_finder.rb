require 'nokogiri'
require 'addressable/uri'
require 'json'
require 'rest-client'

def get_api_key
  api_key = nil
  begin
    api_key = File.read('.api_key').chomp
  rescue
    puts "Unable to read '.api_key'. Please provide a valid Google API key."
  end
  api_key
end

def get_what
  puts "What would you like? "
  gets.chomp
end

def get_current_address
  puts "Please enter current address: "
  gets.chomp
end

def format_url(options = {})

  default = {
    :scheme => "https",
    :host => "maps.googleapis.com",
    :path => "/maps/api/geocode/json",
  }
  default = default.merge(options)
  puts default
  Addressable::URI.new(default).to_s
end


def find
  key = get_api_key
  search_item = get_what
  current_address = get_current_address
  query_vals = {
    :query_values => {
      :key => key,
      :address => current_address
    }
  }

  response = RestClient.get(format_url(query_vals))
  geolocation = JSON.parse(response)
  start_lat = geolocation["results"][0]["geometry"]["location"]["lat"]
  start_lng = geolocation["results"][0]["geometry"]["location"]["lng"]

  search_nearby_item = {
    :scheme => "https",
    :host => "maps.googleapis.com",
    :path => "/maps/api/place/textsearch/json",
    :query_values => {
      :key => key,
      :location => "#{start_lat},#{start_lng}",
      :query => search_item,
      :radius => 3000
    }
  }
  puts format_url(search_nearby_item)
  # response = RestClient.get(format_url(search_nearby_item))
  # item_locations = JSON.parse(response)
  # puts item_locations

end