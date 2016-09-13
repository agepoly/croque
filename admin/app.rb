#!/usr/local/bin/ruby
require 'sinatra/base'
require 'rack/mount'
require 'net/http'
require 'sequel'

require './models'

class Admin < Sinatra::Base
	get '/' do
		'Admin Site, get out!!'
	end

	set :port, 8080
	set :bind, '0.0.0.0'
	run!
end
