#
# SearchV1App.rb
# Copyright © 2020 Matt Nunes-Spraggs
#

require 'sinatra/base'
require 'sinatra/json'
require_relative '../Models/UserService'

##
# The V1 Search API +Sinatra::Base+ application.
class SearchV1App < Sinatra::Base

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

	run! if __FILE__ == $0

end