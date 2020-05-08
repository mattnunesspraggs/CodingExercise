#
# UserService.rb
# Copyright © 2020 Matt Nunes-Spraggs
#

require_relative './User'
require 'yaml'

# A class representing a +User+ search service. In this case,
# it maintains a list of users in memory, loaded from a file.
class UserService

	attr_reader :users

	##
	# Initializes a +UserService+ with the users loaded from
	# the YAML file at +filename+.
	def initialize(filename)
		@users = YAML::load File.read(filename)
	end

	# Returns a list of users (or an empty list) that match
	# +query+. The search performed is a prefix search on the
	# following user fields:
	# - +username+
	# - +name.values+
	# - +display_name+
	# - +email+
	# - +phone.values+
	def users_matching(query)
		regex = /^#{query}/i
		@users.select do |user|
			user.username =~ regex								\
				|| user.name.values.any? { |c| c =~ regex }		\
				|| user.display_name =~ regex					\
				|| user.email =~ regex							\
				|| user.phone.values.any? { |p| p =~ regex }
		end
	end

end