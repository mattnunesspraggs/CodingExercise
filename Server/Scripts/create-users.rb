#/usr/bin/env ruby

##
# A simple script that downloads random users from randomuser.me,
# maps them into the correct format, and then prints the result
# to stdout as YAML.
#
# Example:
#     ruby Scripts/create-users.rb > Data/users-v1.yaml

require 'net/http'
require 'json'
require './Models/User'
require 'securerandom'
require 'yaml'

uri = URI('https://randomuser.me/api/1.3')
uri.query = URI.encode_www_form({
	:inc => "name,email,picture,phone,cell,location,nat",
	:nat => 'au,br,ca,ch,de,dk,es,fi,fr,gb,ie,no,nl,nz,tr,us',
	:noinfo => '',
	:results => 250
})

response = Net::HTTP.get_response(uri)
unless response.is_a?(Net::HTTPSuccess)
	puts "ERROR: #{response.inspect}"
	exit 1
end

body_json = JSON::parse response.body, symbolize_names: true
results = body_json[:results]

users = results.map do |json|
	User.new(
		id: SecureRandom::uuid,
		name: json[:name],
		location: User::Location.new(
			hash: json[:location],
			nationality: json[:nat]),
		email: json[:email],
		phone_numbers: { home: json[:phone], cell: json[:cell] },
		pictures: json[:picture],
		nationality: json[:nat])
end

puts YAML::dump(users)