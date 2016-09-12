#!/usr/local/bin/ruby
require 'sinatra/base'
require 'rack/mount'
require 'net/http'
require 'sequel'

require './models'
require './api'
require './admin'

class Routes < Sinatra::Base
	get('/api*') { App.call(env) }
	get('/burger*') {Admin.call(env) }

	set :port, 8080
	set :bind, '0.0.0.0'
	run!
end
