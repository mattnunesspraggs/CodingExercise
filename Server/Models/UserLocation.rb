#
# UserLocation.rb
# Copyright © 2020 Matt Nunes-Spraggs
#

require_relative './User'
require 'json'

class User

	class Location

		attr_accessor :street, :city, :state, :country, :postcode, :tz_offset

		##
		# Generates the correct(ish) street string from a location
		# +Hash+'s +street+ +Hash+ +({name: "Main St", number: 123})+
		# based on the reported nationality - namely, putting the
		# street number before or after the street name.
		#
		# Examples:
		# - Anglophone countries: "123 Main Street"
		# - Francophone countries, Québec: "123, rue Main"
		# - Other countries: "Main Straße 123"
		def self.street_string(location, nationality)
			street = location[:street]
			case nationality
			when 'AU', 'GB', 'IE', 'NZ', 'US'
				street[:number].to_s + ' ' + street[:name]
			when 'CA'
				case location[:state]
				when 'Québec'
					street[:number].to_s + ', ' + street[:name]
				else
					street[:number].to_s + ' ' + street[:name]
				end
			when 'FR'
				street[:number].to_s + ', ' + street[:name]
			else
				street[:name] + ' ' + street[:number].to_s
			end
		end

		##
		# Initializes a +Location+ object.
		def initialize(hash:, nationality:)
			@street = Location::street_string(hash, nationality)
			@city = hash[:city]
			@state = hash[:state]
			@country = hash[:country]
			@postcode = hash[:postcode]
			@tz_offset = hash[:timezone][:offset]
		end

		def to_json(*a)
			{
				street: @street,
				city: @city,
				state: @state,
				country: @country,
				postcode: @postcode,
				tz_offset: @tz_offset
			}.to_json(*a)
		end

	end

end