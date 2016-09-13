#!/usr/local/bin/ruby
require 'sinatra/base'
require 'rack/mount'
require 'net/http'
require 'sequel'

require './models'

class Admin < Sinatra::Base
	get '/' do
		protected!
		"Bravo, t'es un bon!"
	end

	get '/login' do
		'<form action="/login" method="post"><input type="text" name="login" placeholder="Username"><input type="password" name="password" placeholder="Password"><input type="submit" value="Login"></form>'
	end

	post '/login' do
		if params[:login]=="admin" && params[:password]=="jaimelesburgers"
			session[:logged] = "admin_true"
			redirect '/'
		else
			redirect '/login'
		end
	end

	helpers do
		def protected!
			if session[:logged] == "admin_true"
				true
			else
				halt 401, "401 - Not authorized. <a href=\"/login\">Login &raquo;</a>\n"
			end
		end
	end

	set :port, 8080
	set :bind, '0.0.0.0'
	enable :sessions
	run!
end
