#!/usr/local/bin/ruby
require 'sinatra/base'


class App < Sinatra::Base

	get '/' do
		'Put this in your pipe & smoke it!'
	end

	set :port, 8080
	set :bind, '0.0.0.0'
	run!
end

