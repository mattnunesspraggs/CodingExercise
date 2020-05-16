#
# UsersV1App.rb
# Copyright © 2020 Matt Nunes-Spraggs
#

require 'sinatra/base'
require 'sinatra/json'
require_relative '../Models/UserService'

##
# The V1 Users API +Sinatra::Base+ application.
class UsersV1App < Sinatra::Base

	configure do
		# user_service will be available in all endpoints
		set :user_service, UserService.new('./Data/users.yaml')
	end

	##
	# Performs a search for users.
	get '/users/search' do
		halt 400, 'query must not be nil' unless params.has_key? "query"

		query = params["query"]
		user_service = settings.user_service
		matching_users = user_service.users_matching query

		json({
			:ok => !matching_users.empty?,
			:users => matching_users
		})
	end

	##
	# Returns a user for a given identifier.
	get '/users/:identifier' do
		identifier = params['identifier']
		user_service = settings.user_service
		matching_user = user_service.user_with_id(identifier)

		halt(404) if matching_user.nil?
		json matching_user
	end


	##
	# Redirects to a user's picture for a given size.
	get '/users/:identifier/pictures/:size' do
		identifier = params['identifier']
		picture_size = params['size'].to_sym
		user_service = settings.user_service
		matching_user = user_service.user_with_id(identifier)

		halt(404) if matching_user.nil?

		picture_url = matching_user.pictures[picture_size]
		halt(404) if picture_url.nil?

		redirect picture_url
	end

end