#!/usr/local/bin/ruby
require 'sinatra/base'
require 'rack/mount'
require 'net/http'
require 'sequel'

require './models'
require './users'
require './lunches'

class Routes < Sinatra::Base
	get('/users*') { UserApp.call(env) }
	get('/lunches*') {LunchApp.call(env) }

	set :port, 8080
	set :bind, '0.0.0.0'
	run!
end
