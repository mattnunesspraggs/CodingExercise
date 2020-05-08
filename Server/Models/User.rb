#
# User.rb
# Copyright © 2020 Matt Nunes-Spraggs
#

require 'json'

##
# Class representing a `User` object.
class User

	attr_reader :name, :username, :location, :email,	\
		:phone, :picture, :nationality

	##
	# Generates a username from the user's name +Hash+, which
	# should contain values for the keys +:first+ and +:last+.
	#
	# Example:
	#     User.username_for_name({ first: "John", last: "Smith" })
	#         => "jsmith"
	def self.username_for_name(name)
		(name[:first][0] + name[:last]).downcase
	end

	##
	# Initializes a `User`.
	def initialize(id:, name:, location:, email:, phone:, picture:, nationality:)
		@id = id
		@name = name
		@username = User::username_for_name(@name)
		@location = location
		@email = email
		@phone = phone
		@picture = picture
		@nationality = nationality
	end

	##
	# The user's display name, based on the name +Hash+.
	#
	# Example:
	#     user = User.new(name: { first: "John", last: "Smith" }, ...)
	#     user.display_name
	#         => "John Smith"
	def display_name
		name[:first] + ' ' + name[:last]
	end

	def to_json(*a)
		{
			id: @id,
			name: @name,
			username: @username,
			location: @location,
			email: @email,
			phone: @phone,
			picture: @picture,
			nationality: @nationality
		}.to_json(*a)
	end

end

require_relative './UserLocation'